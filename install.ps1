<#
.SYNOPSIS
Installs the "malewicz-design" skill for Claude Code (Windows PowerShell 5.1 and PowerShell 7+).

.DESCRIPTION
Keep this file and install.sh in sync (same payload, same flags, same messages).

Two modes:
  local  - run from a clone (SKILL.md + references\ next to this script).
  remote - run through "irm ... | iex", a scriptblock, a lone downloaded copy, or
           with -Version/-Ref: downloads the GitHub archive and installs from it.

Exit codes: 0 ok, 1 usage/validation error, 2 already installed (use -Force).
When not run from a file (iex / scriptblock) the script never calls "exit": it
sets $global:LASTEXITCODE and returns, so the user's terminal stays open.

Environment overrides (tests and forks): MALEWICZ_ARCHIVE_BASE, MALEWICZ_RAW_BASE.
Run "./install.ps1 -Help" for usage (pt-BR).

Download limits: archive <= 20 MB, <= 2000 entries, <= 50 MB uncompressed; the zip
is extracted with .NET after every entry name has been validated (no Expand-Archive).

Known limitations:
 - "irm ... | iex" runs the script's param block in the caller's scope, so the 9
   variables $Project $Global $Force $Uninstall $DryRun $Version $Ref $Help $Rest are
   reset in that session. Use the scriptblock form when options are needed:
   & ([scriptblock]::Create((irm <url>))) -Global -Force
 - Windows PowerShell 5.1 started in a folder whose path contains [ ] resolves the
   current location to the wrong folder (e.g. System32\WindowsPowerShell\v1.0). When no
   project folder is given the script refuses to guess in that situation (exit 1);
   pass the project folder explicitly.
#>
[CmdletBinding()]
param(
    [Parameter(Position = 0)][Alias('Path')][string]$Project,
    [switch]$Global,
    [switch]$Force,
    [switch]$Uninstall,
    [switch]$DryRun,
    [string]$Version,
    [string]$Ref,
    [Alias('h')][switch]$Help,
    # Catches unknown switches so we can print the usage instead of a raw binding error.
    [Parameter(ValueFromRemainingArguments = $true)][string[]]$Rest
)

# Everything runs in a child scope so that "irm | iex" does not leak functions,
# strict mode or preferences into the user's session. The parameter list is
# repeated on purpose: it re-binds @PSBoundParameters and keeps the defaults
# (e.g. $Force = $false) independent of whatever the caller's session holds.
& {
    [CmdletBinding()]
    param(
        [string]$Project,
        [switch]$Global,
        [switch]$Force,
        [switch]$Uninstall,
        [switch]$DryRun,
        [string]$Version,
        [string]$Ref,
        [switch]$Help,
        [string[]]$Rest
    )

    $Bound = $PSBoundParameters   # functions below have their own $PSBoundParameters
    Set-StrictMode -Version 2.0
    $ErrorActionPreference = 'Stop'
    $ProgressPreference = 'SilentlyContinue'   # Invoke-WebRequest is very slow in 5.1 with the progress bar

    $SkillName = 'malewicz-design'
    $ArchiveBase = if ($env:MALEWICZ_ARCHIVE_BASE) { $env:MALEWICZ_ARCHIVE_BASE } else { 'https://github.com/Maccena/Malewicz-Design' }
    $RawBase     = if ($env:MALEWICZ_RAW_BASE) { $env:MALEWICZ_RAW_BASE } else { 'https://raw.githubusercontent.com/Maccena/Malewicz-Design' }
    $ArchiveBase = $ArchiveBase.TrimEnd('/')
    $RawBase = $RawBase.TrimEnd('/')

    # Payload: the ONLY things copied into the skill folder (relative to the source
    # folder; directories are copied recursively). Keep in sync with PAYLOAD in
    # install.sh. LICENSE is optional, the rest is required.
    $Payload  = @('SKILL.md', 'references', 'LICENSE')
    $Required = @('SKILL.md', 'references')

    # Mutable state shared with the functions below (assigning a plain variable in a function would create a copy).
    $State = @{ ExitCode = $null; SrcDir = $null; Tmp = $null; Ref = $null; NewVersion = 'desconhecida'; LatestDerived = $false }
    $MaxArchiveBytes = 20000000
    $MaxUncompressedBytes = 50MB
    $MaxEntries = 2000

    function Fail([string]$Message, [int]$Code = 1, [switch]$NoPrefix) {
        $prefix = if ($NoPrefix) { '' } else { 'Erro: ' }
        Warn ($prefix + $Message)
        $State.ExitCode = $Code
        throw 'install-abort'
    }

    # Messages for the user: stderr from a file, plain host output from iex/scriptblock.
    function Warn([string]$Message) {
        if ($PSCommandPath) { [Console]::Error.WriteLine($Message) } else { Write-Host $Message }
    }

    function Show-Usage {
@"
Instala a skill $SkillName no Claude Code.

Uso:
  .\install.ps1 [opcoes] [PASTA_DO_PROJETO]
  install.cmd   [opcoes] [PASTA_DO_PROJETO]   (nao exige mudar a ExecutionPolicy)
  irm $RawBase/main/install.ps1 | iex
  & ([scriptblock]::Create((irm $RawBase/main/install.ps1))) -Global -Force

Por padrao instala no projeto (PASTA_DO_PROJETO, ou o diretorio atual) em
<projeto>\.claude\skills\$SkillName
Dentro de um clone instala a copia local; fora dele (ou com -Version/-Ref)
baixa o pacote do GitHub (ultima versao por padrao).
(pastas que comecam com "-": use .\-pasta)

Opcoes:
  -Global         instala para o usuario em %USERPROFILE%\.claude\skills\$SkillName
  -Force          substitui uma instalacao existente (remove arquivos antigos)
  -Uninstall      remove a skill instalada
  -DryRun         mostra o que seria feito, sem alterar nada
  -Version X.Y.Z  instala essa versao (tag vX.Y.Z); modo remoto
  -Ref NOME       instala de um branch ou tag (ex.: main); modo remoto
  -Help, -h       mostra esta ajuda

Exemplos:
  .\install.ps1                       # instala no projeto atual
  .\install.ps1 C:\meus\projetos\site # instala em outro projeto
  .\install.ps1 -Global               # instala para todos os seus projetos
  .\install.ps1 -Force                # atualiza uma instalacao existente
  .\install.ps1 -Version 1.0.0        # baixa e instala a versao 1.0.0
  .\install.ps1 -Uninstall            # remove do projeto atual
  .\install.ps1 -Global -Uninstall    # remove da pasta pessoal

Codigos de saida: 0 sucesso, 1 erro de uso/validacao, 2 ja instalado (sem -Force).
"@
    }

    # Follows the final component if it is a symlink (enough for the usual case).
    function Resolve-Link([string]$File) {
        $item = Get-Item -LiteralPath $File -Force
        if ($item.PSObject.Properties['LinkType'] -and $item.LinkType -eq 'SymbolicLink' -and $item.Target) {
            $target = @($item.Target)[0]
            if (-not [IO.Path]::IsPathRooted($target)) { $target = Join-Path (Split-Path -Parent $File) $target }
            return [IO.Path]::GetFullPath($target)
        }
        return [IO.Path]::GetFullPath($File)
    }

    # Absolute path of an existing file-system folder (accepts trailing "\" or "\.").
    function Resolve-Dir([string]$Dir) {
        $resolved = Resolve-Path -LiteralPath $Dir
        if ($resolved.Provider.Name -ne 'FileSystem') {
            Fail "o caminho nao e uma pasta do sistema de arquivos: $Dir"
        }
        $full = [IO.Path]::GetFullPath($resolved.ProviderPath)
        $root = [IO.Path]::GetPathRoot($full)
        if ($full.Length -gt $root.Length) { $full = $full.TrimEnd('\', '/') }
        return $full
    }

    function Get-Comparison {
        if ($env:OS -eq 'Windows_NT') { return [StringComparison]::OrdinalIgnoreCase }
        return [StringComparison]::Ordinal
    }

    function Test-SamePath([string]$A, [string]$B) {
        return [string]::Equals($A.TrimEnd('\', '/'), $B.TrimEnd('\', '/'), (Get-Comparison))
    }

    function Test-Inside([string]$Child, [string]$Parent) {
        $prefix = $Parent.TrimEnd('\', '/') + [IO.Path]::DirectorySeparatorChar
        return $Child.StartsWith($prefix, (Get-Comparison))
    }

    function Test-Exists([string]$P) {
        # Test-Path is false for dangling links, so also ask the file system directly.
        return ((Test-Path -LiteralPath $P) -or [bool](Get-Item -LiteralPath $P -Force -ErrorAction SilentlyContinue))
    }

    function Count-Files([string]$Dir) {
        return @(Get-ChildItem -LiteralPath $Dir -Recurse -File -Force).Count
    }

    # True if SKILL.md has "name: malewicz-design" inside its first frontmatter block
    # (between the first two --- lines). Case-sensitive; BOM and CRLF tolerated.
    function Test-OurSkill([string]$Dir) {
        $md = Join-Path $Dir 'SKILL.md'
        if (-not (Test-Path -LiteralPath $md -PathType Leaf)) { return $false }
        $lines = [IO.File]::ReadAllLines($md)
        $fence = '^---[ \t]*$'
        $namePattern = '^name:[ \t]*(' + [regex]::Escape($SkillName) + '|"' + [regex]::Escape($SkillName) + '"|''' + [regex]::Escape($SkillName) + ''')[ \t]*$'
        if ($lines.Count -eq 0 -or $lines[0] -cnotmatch $fence) { return $false }
        $found = $false
        for ($i = 1; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -cmatch $fence) { return $found }
            if ($lines[$i] -cmatch $namePattern) { $found = $true }
        }
        return $false   # frontmatter never closed
    }

    # The version declared in the frontmatter of $File, or 'desconhecida'. Only an
    # indented line "  version: X.Y.Z" (optional quotes and leading v) inside the first
    # frontmatter block counts. CRLF/BOM tolerated. Never fails.
    function Get-SkillVersion([string]$File) {
        try {
            if (Test-Path -LiteralPath $File -PathType Leaf) {
                $lines = [IO.File]::ReadAllLines($File)
                if ($lines.Count -gt 0 -and $lines[0] -cmatch '^---[ \t]*$') {
                    for ($i = 1; $i -lt $lines.Count; $i++) {
                        if ($lines[$i] -cmatch '^---[ \t]*$') { break }
                        if ($lines[$i] -cmatch '^[ \t]+version:[ \t]*["'']?v?([0-9]+\.[0-9]+\.[0-9]+)["'']?[ \t]*$') { return $Matches[1] }
                    }
                }
            }
        } catch { }
        return 'desconhecida'
    }

    # Files in the destination that are not part of the payload (relative, forward slashes).
    # Without a source folder (remote uninstall) only the top-level names are compared.
    function Get-ExtraFiles([string]$Dir) {
        $prefix = $Dir.TrimEnd('\', '/') + [IO.Path]::DirectorySeparatorChar
        $extras = @()
        foreach ($f in @(Get-ChildItem -LiteralPath $Dir -Recurse -File -Force)) {
            $rel = $f.FullName.Substring($prefix.Length).Replace('\', '/')
            $top = $rel.Split('/')[0]
            $isPayload = $false
            if ($Payload -ccontains $top) {
                $isPayload = (-not $State.SrcDir) -or (Test-Path -LiteralPath (Join-Path $State.SrcDir $rel) -PathType Leaf)
            }
            if (-not $isPayload) { $extras += $rel }
        }
        return $extras
    }

    function Write-ExtrasWarning([string]$Dir) {
        $extras = @(Get-ExtraFiles $Dir)
        if ($extras.Count -eq 0) { return }
        Warn "Aviso: $($extras.Count) arquivo(s) que nao fazem parte da skill serao removidos de ${Dir}:"
        $extras | Select-Object -First 20 | ForEach-Object { Warn "  $_" }
        if ($extras.Count -gt 20) { Warn "  ... e mais $($extras.Count - 20)" }
    }

    function Remove-Tree([string]$P) {
        $item = Get-Item -LiteralPath $P -Force -ErrorAction SilentlyContinue
        if (-not $item) { return }
        if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
            # Link/junction: remove the link only, never its target's contents.
            if ($item.PSIsContainer) { [IO.Directory]::Delete($item.FullName) } else { [IO.File]::Delete($item.FullName) }
        } else {
            Remove-Item -LiteralPath $P -Recurse -Force
        }
    }

    # Remove leftovers of interrupted runs (exact name patterns only; dead pid or older than 1 day).
    function Clear-Stale([string[]]$Dirs) {
        foreach ($d in $Dirs) {
            if (-not (Test-Path -LiteralPath $d -PathType Container)) { continue }
            foreach ($kind in 'new', 'del') {
                $found = @(Get-ChildItem -LiteralPath $d -Force -Directory -Filter ".$SkillName.$kind.*" -ErrorAction SilentlyContinue)
                foreach ($p in $found) {
                    if ($p.Attributes -band [IO.FileAttributes]::ReparsePoint) { continue }
                    if ($p.Name -notmatch '\.(\d+)$') { continue }
                    $alive = [bool](Get-Process -Id ([int]$Matches[1]) -ErrorAction SilentlyContinue)
                    $old = $p.LastWriteTime -lt (Get-Date).AddDays(-1)
                    if ($alive -and -not $old) { continue }
                    try { Remove-Tree $p.FullName } catch { }
                }
            }
        }
    }

    # ------------------------------------------------------------ remote mode

    # X.Y.Z with an optional leading v (nothing else).
    function Test-VersionString([string]$V) { return ($V -cmatch '^v?[0-9]+\.[0-9]+\.[0-9]+\z') }

    # Branch/tag name: [A-Za-z0-9._/-]+, not starting with - or /, no "..".
    function Test-RefString([string]$R) {
        return (($R -cmatch '^[A-Za-z0-9._/-]+\z') -and -not $R.StartsWith('-') -and -not $R.StartsWith('/') -and -not $R.Contains('..'))
    }

    function Get-Tmp {
        if (-not $State.Tmp) {
            $p = Join-Path ([IO.Path]::GetTempPath()) ("$SkillName." + [guid]::NewGuid().ToString('N').Substring(0, 8))
            New-Item -ItemType Directory -Path $p | Out-Null
            $State.Tmp = $p
        }
        return $State.Tmp
    }

    # Returns $true on success; otherwise $false with the reason in $State.DownloadError / $State.DownloadStatus.
    function Try-Download([string]$Url, [string]$OutFile, [int]$TimeoutSec) {
        $State.DownloadError = $null; $State.DownloadStatus = 0
        if ($Url -like 'https://*') {
            # Only add Tls12 when the process default is explicit and lacks it (never downgrade SystemDefault/Tls13).
            try {
                $cur = [int][Net.ServicePointManager]::SecurityProtocol
                if ($cur -ne 0 -and -not ($cur -band (3072 -bor 12288))) {
                    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]($cur -bor 3072)
                }
            } catch { }
        }
        try {
            Invoke-WebRequest -UseBasicParsing -Uri $Url -OutFile $OutFile -TimeoutSec $TimeoutSec
            return $true
        } catch {
            $State.DownloadError = $_.Exception.Message
            $resp = $_.Exception.PSObject.Properties['Response']
            if ($resp -and $resp.Value -and $resp.Value.PSObject.Properties['StatusCode']) {
                $State.DownloadStatus = [int]$resp.Value.StatusCode
            }
            return $false
        }
    }

    # $NotFoundHint replaces the generic "may not exist / private" text for HTTP errors.
    function Get-RemoteFile([string]$Url, [string]$OutFile, [int]$TimeoutSec, [string]$NotFoundHint = '') {
        if (Try-Download $Url $OutFile $TimeoutSec) { return }
        if ($State.DownloadStatus -ge 400) {
            if ($NotFoundHint) { Fail $NotFoundHint }
            Fail "o servidor respondeu com erro HTTP $($State.DownloadStatus) ao baixar $Url (o repositorio ou a tag pode nao existir, ou o repositorio pode ser privado)"
        }
        Fail "falha de rede ao baixar ${Url}: $($State.DownloadError)"
    }

    # Decides $State.Ref (what to download) and $State.NewVersion (what it will announce).
    function Resolve-Remote {
        if ($env:MALEWICZ_RAW_BASE -or $env:MALEWICZ_ARCHIVE_BASE) {
            Warn "Aviso: usando base alternativa (raw: $RawBase; arquivo: $ArchiveBase)"
        }
        $tmp = Get-Tmp
        $meta = Join-Path $tmp 'remote-SKILL.md'
        if ($Version) {
            $State.NewVersion = $Version -replace '^v', ''
            $State.Ref = 'v' + $State.NewVersion
        } elseif ($Ref) {
            $State.Ref = $Ref
            if (Try-Download "$RawBase/$Ref/SKILL.md" $meta 30) { $State.NewVersion = Get-SkillVersion $meta }
        } else {
            Get-RemoteFile "$RawBase/main/SKILL.md" $meta 30
            $v = Get-SkillVersion $meta
            if (-not (Test-VersionString $v)) {
                Fail "nao foi possivel descobrir a ultima versao (campo 'version:' ausente ou invalido em $RawBase/main/SKILL.md). Use -Version X.Y.Z ou -Ref main."
            }
            $State.NewVersion = $v
            $State.Ref = "v$v"
            $State.LatestDerived = $true
        }
    }

    # Checks the extracted folder $Dir before anything is installed from it.
    function Test-Payload([string]$Dir) {
        if (-not (Test-Path -LiteralPath (Join-Path $Dir 'SKILL.md') -PathType Leaf)) { Fail 'o pacote baixado nao tem SKILL.md' }
        if (-not (Test-OurSkill $Dir)) { Fail "o SKILL.md do pacote baixado nao tem 'name: $SkillName' no frontmatter" }
        $refs = Join-Path $Dir 'references'
        if (-not (Test-Path -LiteralPath $refs -PathType Container) -or @(Get-ChildItem -LiteralPath $refs -Recurse -File -Force).Count -eq 0) {
            Fail 'o pacote baixado nao tem references/ (ou esta vazia)'
        }
        $text = [IO.File]::ReadAllText((Join-Path $Dir 'SKILL.md'))
        $links = @([regex]::Matches($text, 'references/[A-Za-z0-9._/-]+\.md') | ForEach-Object { $_.Value } | Sort-Object -Unique)
        $unsafe = @($links | Where-Object { $_.Contains('..') -or $_.StartsWith('/') })
        if ($unsafe.Count -gt 0) {
            Fail "o SKILL.md do pacote contem um link inseguro para references/ ($($unsafe -join ' ')); nada foi instalado"
        }
        $missing = @($links | Where-Object { -not (Test-Path -LiteralPath (Join-Path $Dir $_) -PathType Leaf) })
        if ($missing.Count -gt 0) {
            Fail "o SKILL.md do pacote referencia arquivos que nao existem no pacote: $($missing -join ' ')"
        }
    }

    # Why a zip entry name is unsafe to extract under $Root, or $null when it is fine.
    function Get-ZipEntryProblem([string]$Name, [string]$Root) {
        if ($Name -match '[\x00-\x1f]') { return "nome de entrada com caracteres de controle" }
        if ($Name.Contains('\') -or $Name.Contains(':')) { return "nome de entrada com '\' ou ':' ($Name)" }
        if ($Name.StartsWith('/')) { return "caminho absoluto ($Name)" }
        foreach ($seg in $Name.Split('/')) {
            if ($seg -eq '') { continue }
            if ($seg -eq '..') { return "segmento '..' ($Name)" }
            if ($seg -match '^(CON|PRN|AUX|NUL|COM[1-9]|LPT[1-9])(\..*)?$') { return "nome reservado do Windows ($Name)" }
            if ($seg.EndsWith('.') -or $seg.EndsWith(' ')) { return "segmento terminado em '.' ou espaco ($Name)" }
        }
        $dst = [IO.Path]::GetFullPath((Join-Path $Root $Name))
        if (-not $dst.StartsWith($Root, (Get-Comparison))) { return "entrada fora da pasta de extracao ($Name)" }
        return $null
    }

    # Downloads and extracts the archive of $State.Ref into the temp folder; sets $State.SrcDir.
    function Expand-Source {
        $tmp = Get-Tmp
        $zip = Join-Path $tmp 'source.zip'
        $x = Join-Path $tmp 'x'
        New-Item -ItemType Directory -Path $x | Out-Null
        $hint = ''
        if ($State.LatestDerived) {
            $hint = "a ultima versao declarada e $($State.NewVersion), mas a tag $($State.Ref) ainda nao foi publicada; tente -Version <versao anterior> ou -Ref main"
        }
        Get-RemoteFile "$ArchiveBase/archive/$($State.Ref).zip" $zip 120 $hint
        if ((Get-Item -LiteralPath $zip).Length -gt $MaxArchiveBytes) { Fail 'o pacote baixado excede o limite de 20 MB' }

        # Validate every entry name first, then extract with .NET (nothing is written before all names pass).
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        $root = [IO.Path]::GetFullPath($x).TrimEnd('\', '/') + [IO.Path]::DirectorySeparatorChar
        $archive = $null
        try { $archive = [IO.Compression.ZipFile]::OpenRead($zip) } catch { Fail 'o arquivo baixado nao e um zip valido' }
        $problem = $null
        try {
            $entries = @($archive.Entries)
            if ($entries.Count -gt $MaxEntries) { $problem = "o pacote baixado tem entradas demais (limite $MaxEntries)" }
            $total = 0L
            foreach ($e in $entries) { $total += $e.Length }
            if (-not $problem -and $total -gt $MaxUncompressedBytes) { $problem = 'o pacote baixado excede 50 MB descompactado' }
            if (-not $problem) {
                foreach ($e in $entries) {
                    $why = Get-ZipEntryProblem $e.FullName $root
                    if ($why) { $problem = "o pacote baixado contem caminhos inseguros: $why; nada foi instalado"; break }
                }
            }
            if (-not $problem) {
                foreach ($e in $entries) {
                    $dst = [IO.Path]::GetFullPath((Join-Path $root $e.FullName))
                    if ($e.FullName.EndsWith('/')) {
                        [void][IO.Directory]::CreateDirectory($dst)
                    } else {
                        [void][IO.Directory]::CreateDirectory([IO.Path]::GetDirectoryName($dst))
                        [IO.Compression.ZipFileExtensions]::ExtractToFile($e, $dst, $false)
                    }
                }
            }
        } catch {
            $problem = "falha ao extrair o pacote baixado: $($_.Exception.Message)"
        } finally {
            $archive.Dispose()
        }
        if ($problem) { Fail $problem }

        $links = @(Get-ChildItem -LiteralPath $x -Recurse -Force | Where-Object { $_.Attributes -band [IO.FileAttributes]::ReparsePoint })
        if ($links.Count -gt 0) { Fail 'o pacote baixado contem links; nada foi instalado' }
        $top = @(Get-ChildItem -LiteralPath $x -Force)
        if ($top.Count -ne 1 -or -not $top[0].PSIsContainer) {
            Fail 'o pacote baixado tem estrutura inesperada (esperada uma unica pasta raiz)'
        }
        $State.SrcDir = $top[0].FullName
        Test-Payload $State.SrcDir
        $got = Get-SkillVersion (Join-Path $State.SrcDir 'SKILL.md')
        if ($got -ne 'desconhecida') { $State.NewVersion = $got }
    }

    # ------------------------------------------------------------------- main

    function Invoke-Core {
        if ($Help) { Show-Usage | Out-Host; return 0 }

        if ($Rest -and @($Rest).Count -gt 0) {
            Warn ((Show-Usage) -join "`n")
            Fail "opcao ou argumento desconhecido: $(@($Rest) -join ' ') (veja -Help)"
        }
        if ($Bound.ContainsKey('Project') -and [string]::IsNullOrWhiteSpace($Project)) {
            Fail 'a pasta do projeto esta vazia (argumento "")'
        }
        if ($Project -and $Project.StartsWith('-')) {
            Warn ((Show-Usage) -join "`n")
            Fail "opcao desconhecida: $Project (veja -Help; para pastas que comecam com '-' use .\$Project)"
        }
        if ($Global -and $Project) { Fail '-Global nao pode ser usado junto com uma pasta de projeto' }
        $haveVersion = $Bound.ContainsKey('Version')
        $haveRef = $Bound.ContainsKey('Ref')
        if ($haveVersion -and $haveRef) { Fail '-Version e -Ref nao podem ser usados juntos' }
        if ($haveVersion -and -not (Test-VersionString $Version)) { Fail 'versao invalida: use X.Y.Z (ex.: 1.0.0)' }
        if ($haveRef -and -not (Test-RefString $Ref)) {
            Fail "ref invalido: use apenas letras, numeros, . _ / - (sem comecar com - ou /, sem '..')"
        }

        # Locate this script (empty from iex/scriptblock). Local mode: payload next to it, no -Version/-Ref.
        $scriptDir = $null
        if ($PSCommandPath -and (Test-Path -LiteralPath $PSCommandPath -PathType Leaf)) {
            $scriptDir = Split-Path -Parent (Resolve-Link $PSCommandPath)
        }
        $isLocal = [bool]$scriptDir -and -not $haveVersion -and -not $haveRef -and
            (Test-Path -LiteralPath (Join-Path $scriptDir 'SKILL.md')) -and (Test-Path -LiteralPath (Join-Path $scriptDir 'references'))
        if ($isLocal) { $State.SrcDir = $scriptDir }

        # Destination
        if ($Global) {
            $userHome = if ($env:USERPROFILE) { $env:USERPROFILE } else { $env:HOME }
            if (-not $userHome -or -not (Test-Path -LiteralPath $userHome -PathType Container)) {
                Fail 'pasta pessoal (USERPROFILE/HOME) nao definida ou inexistente'
            }
            $base = Resolve-Dir $userHome
        } else {
            $path = $Project
            $implicit = -not $path
            if ($implicit) { $path = (Get-Location).Path }
            if (-not (Test-Path -LiteralPath $path -PathType Container)) { Fail "a pasta do projeto nao existe: $path" }
            $base = Resolve-Dir $path
            if ($implicit) {
                # The current folder is a guess; Windows PowerShell 5.1 resolves it wrongly when the
                # start-up path contains [ ]. An explicit project folder skips these checks.
                $explicitHint = "Informe a pasta do projeto explicitamente: .\install.ps1 C:\caminho\do\projeto  (ou  & ([scriptblock]::Create((irm $RawBase/main/install.ps1))) C:\caminho\do\projeto)"
                if ($env:windir -and ((Test-SamePath $base $env:windir) -or (Test-Inside $base $env:windir))) {
                    Fail "a pasta atual ($base) fica dentro do Windows; isso nao parece ser o seu projeto. $explicitHint"
                }
                $locProvider = (Get-Location).ProviderPath
                $procCwd = [Environment]::CurrentDirectory
                if (-not (Test-SamePath $locProvider $procCwd) -and (($locProvider -match '[\[\]]') -or ($procCwd -match '[\[\]]'))) {
                    Fail "nao foi possivel confirmar a pasta atual (local do PowerShell: $locProvider; processo: $procCwd). O Windows PowerShell 5.1 resolve mal pastas com [ ] no caminho. $explicitHint"
                }
            }
            if ($isLocal -and (Test-SamePath $base $scriptDir)) {
                Fail "o projeto de destino e o proprio repositorio da skill ($scriptDir). Rode o instalador a partir de outro projeto: .\install.ps1 C:\caminho\do\projeto"
            }
        }
        $claudeDir = Join-Path $base '.claude'
        $skillsDir = Join-Path $claudeDir 'skills'
        $dest = Join-Path $skillsDir $SkillName

        # The clone itself must never be the destination (force/uninstall would delete it).
        if ($scriptDir -and (Test-Exists $dest)) {
            $realDest = [IO.Path]::GetFullPath((Resolve-Link $dest))
            if (Test-SamePath $realDest $scriptDir) {
                Fail "a origem e o destino sao a mesma pasta; a skill ja esta instalada neste local ($dest)"
            }
            if (Test-Inside $scriptDir $realDest) {
                Fail "este script esta dentro da pasta de destino ($dest); a origem e o destino se sobrepoem"
            }
        }

        # Uninstall
        if ($Uninstall) {
            if (-not (Test-Exists $dest)) {
                Write-Host "Nada para remover: $SkillName nao esta instalada em $dest"
                return 0
            }
            if (-not (Test-OurSkill $dest)) {
                Fail "$dest nao parece ser a skill $SkillName (SKILL.md ausente ou com outro 'name:'). Nada foi removido."
            }
            Write-ExtrasWarning $dest
            if ($DryRun) { Write-Host "[dry-run] removeria $dest"; return 0 }
            Clear-Stale @($claudeDir, $skillsDir)
            # Rename first (atomic), then delete: the skill is gone from the skills folder even if the delete fails.
            $del = Join-Path $claudeDir ".$SkillName.del.$PID"
            try { [IO.Directory]::Move($dest, $del) } catch {
                Fail "nao foi possivel remover $dest (arquivos em uso?). Nada foi alterado. $($_.Exception.Message)"
            }
            try { Remove-Tree $del } catch {
                Warn "Aviso: a skill foi removida, mas sobrou lixo em $del (apague manualmente)."
            }
            Write-Host "Removido: $dest"
            return 0
        }

        # Source: the clone, or a downloaded archive
        if ($isLocal) {
            foreach ($item in $Required) {
                if (-not (Test-Path -LiteralPath (Join-Path $State.SrcDir $item))) {
                    Fail "'$item' nao encontrado em $($State.SrcDir). Rode este script a partir de um clone completo do repositorio."
                }
            }
            $State.NewVersion = Get-SkillVersion (Join-Path $State.SrcDir 'SKILL.md')
        } else {
            Resolve-Remote
        }

        # Existing install
        $exists = Test-Exists $dest
        $oldVersion = 'desconhecida'
        if ($exists) { $oldVersion = Get-SkillVersion (Join-Path $dest 'SKILL.md') }
        if ($exists -and -not $Force) {
            $msg = "A skill $SkillName ja existe em: $dest"
            if ($oldVersion -eq $State.NewVersion -and $State.NewVersion -ne 'desconhecida') {
                $msg += "`n  ja esta na versao $($State.NewVersion) (use -Force para reinstalar)"
            } else {
                $label = if ($haveVersion) { 'versao solicitada' } else { 'versao a instalar' }
                $msg += "`n  versao instalada: $oldVersion; ${label}: $($State.NewVersion)"
            }
            if (Test-Path -LiteralPath $dest -PathType Container) {
                $names = (Get-ChildItem -LiteralPath $dest -Force | ForEach-Object { $_.Name }) -join ' '
                $msg += "`n  $(Count-Files $dest) arquivo(s); conteudo: $names"
            }
            $msg += "`nUse -Force para substituir (ou -Uninstall para remover)."
            Fail $msg 2 -NoPrefix
        }

        if (-not $isLocal) { Expand-Source }

        if ($exists) {
            if (-not (Test-OurSkill $dest)) {
                Fail "$dest existe mas nao parece ser a skill $SkillName. Nada foi alterado; remova manualmente se quiser substituir."
            }
            Write-ExtrasWarning $dest
        }

        $newVersion = $State.NewVersion
        if (-not $exists) {
            $announce = "instalando $newVersion"
        } elseif ($oldVersion -eq $newVersion -and $newVersion -ne 'desconhecida') {
            $announce = "ja esta na versao $newVersion - reinstalando"
        } else {
            $announce = "instalando $newVersion (substituindo $oldVersion)"
            $strict = '^[0-9]+\.[0-9]+\.[0-9]+\z'
            if (($newVersion -cmatch $strict) -and ($oldVersion -cmatch $strict) -and ([version]$newVersion -lt [version]$oldVersion)) {
                $announce += ' (downgrade)'
            }
        }

        $srcDir = $State.SrcDir
        Write-Host "Destino: $dest"
        if ($DryRun) {
            Write-Host "[dry-run] $announce"
            Write-Host "[dry-run] instalaria em $dest"
            foreach ($item in $Payload) {
                if (Test-Path -LiteralPath (Join-Path $srcDir $item)) { Write-Host "[dry-run]   copiaria $item" }
            }
            if ($exists) { Write-Host '[dry-run]   substituiria a instalacao existente (-Force)' }
            return 0
        }
        Write-Host $announce

        # Install: copy to a temp folder outside skills/, then swap with pure renames.
        Clear-Stale @($claudeDir, $skillsDir)
        $stage = Join-Path $claudeDir ".$SkillName.new.$PID"
        $old   = Join-Path $claudeDir ".$SkillName.del.$PID"
        $swapped = $false
        try {
            New-Item -ItemType Directory -Path $skillsDir -Force | Out-Null
            New-Item -ItemType Directory -Path $stage | Out-Null
            foreach ($item in $Payload) {
                $from = Join-Path $srcDir $item
                if (Test-Path -LiteralPath $from) {
                    Copy-Item -LiteralPath $from -Destination $stage -Recurse -Force
                }
            }

            # Swap: old out, new in. [IO.Directory]::Move is a pure rename (Move-Item may
            # silently fall back to copy+delete). The old copy is deleted only after success.
            if (Test-Exists $dest) {
                try { [IO.Directory]::Move($dest, $old) } catch {
                    Fail "nao foi possivel substituir $dest (arquivos em uso?). A instalacao antiga foi mantida. $($_.Exception.Message)"
                }
            }
            try {
                [IO.Directory]::Move($stage, $dest)
                $swapped = $true
            } catch {
                $reason = $_.Exception.Message
                if ((Test-Exists $old) -and -not (Test-Exists $dest)) {
                    try { [IO.Directory]::Move($old, $dest) } catch {
                        Fail "falha ao instalar e ao restaurar; a instalacao antiga esta em $old. $reason"
                    }
                }
                Fail "falha ao colocar a nova versao em $dest (a instalacao antiga foi restaurada, se existia). $reason"
            }
            try { Remove-Tree $old } catch {
                Warn "Aviso: a versao antiga sobrou em $old (apague manualmente)."
            }
        } finally {
            try {
                if (Test-Exists $stage) { Remove-Tree $stage }
                if (Test-Exists $old) {
                    if ($swapped) { Remove-Tree $old }
                    elseif (-not (Test-Exists $dest)) { [IO.Directory]::Move($old, $dest) }   # interrupted swap: restore
                }
            } catch { }
        }

        Write-Host "Instalado em: $dest ($(Count-Files $dest) arquivos) - versao $newVersion"
        Write-Host ''
        Write-Host "Proximo passo: abra o Claude Code neste projeto e digite /$SkillName"
        Write-Host '(ou apenas peca uma landing page / revisao de UI).'
        Write-Host 'O Claude Code detecta novas pastas de skills automaticamente, mas se a pasta'
        Write-Host '.claude/skills nao existia quando a sessao comecou, use /reload-skills ou reinicie.'
        if (-not $Global) {
            Write-Host ''
            Write-Host 'Para compartilhar com o time, versione a skill no projeto:'
            Write-Host "  git add .claude/skills/$SkillName"
        }
        return 0
    }

    # Always remove the download workspace, whatever happens.
    function Invoke-Main {
        try { return (Invoke-Core) }
        finally {
            if ($State.Tmp) { try { Remove-Tree $State.Tmp } catch { } }
        }
    }

    $code = 1
    try {
        $code = @(Invoke-Main)[-1]
    } catch {
        if ($null -ne $State.ExitCode) { $code = $State.ExitCode }
        else { Warn ('Erro inesperado: ' + $_.Exception.Message); $code = 1 }
    }
    # "exit" would close the user's terminal under "irm | iex" or a scriptblock: only exit from a file.
    if ($PSCommandPath) { exit $code }
    $global:LASTEXITCODE = $code
} @PSBoundParameters
