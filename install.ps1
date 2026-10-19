<#
.SYNOPSIS
Installs the "malewicz-design" skill for Claude Code (Windows PowerShell 5.1 and PowerShell 7+).

.DESCRIPTION
Keep this file and install.sh in sync (same payload, same flags, same messages).
Exit codes: 0 ok, 1 usage/validation error, 2 already installed (use -Force).
Run "./install.ps1 -Help" for usage (pt-BR).
#>
[CmdletBinding()]
param(
    [Parameter(Position = 0)][string]$Path,
    [switch]$Global,
    [switch]$Force,
    [switch]$Uninstall,
    [switch]$DryRun,
    [Alias('h')][switch]$Help,
    # Catches unknown switches so we can print the usage instead of a raw binding error.
    [Parameter(ValueFromRemainingArguments = $true)][string[]]$Rest
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = 'Stop'

$SkillName = 'malewicz-design'

# Payload: the ONLY things copied into the skill folder (relative to this
# script's directory; directories are copied recursively). Keep in sync with
# PAYLOAD in install.sh. LICENSE is optional, the rest is required.
$Payload  = @('SKILL.md', 'references', 'LICENSE')
$Required = @('SKILL.md', 'references')

$script:ExitCode = $null
$script:SrcDir = $null
$script:PathGiven = $PSBoundParameters.ContainsKey('Path')   # not visible from inside functions

function Fail([string]$Message, [int]$Code = 1, [switch]$NoPrefix) {
    $prefix = if ($NoPrefix) { '' } else { 'Erro: ' }
    [Console]::Error.WriteLine($prefix + $Message)
    $script:ExitCode = $Code
    throw 'install-abort'
}

function Warn([string]$Message) { [Console]::Error.WriteLine($Message) }

function Show-Usage {
@"
Instala a skill $SkillName no Claude Code.

Uso:
  .\install.ps1 [opcoes] [PASTA_DO_PROJETO]
  install.cmd   [opcoes] [PASTA_DO_PROJETO]   (nao exige mudar a ExecutionPolicy)

Por padrao instala no projeto (PASTA_DO_PROJETO, ou o diretorio atual) em
<projeto>\.claude\skills\$SkillName
(pastas que comecam com "-": use .\-pasta)

Opcoes:
  -Global      instala para o usuario em %USERPROFILE%\.claude\skills\$SkillName
  -Force       substitui uma instalacao existente (remove arquivos antigos)
  -Uninstall   remove a skill instalada
  -DryRun      mostra o que seria feito, sem alterar nada
  -Help, -h    mostra esta ajuda

Exemplos:
  .\install.ps1                       # instala no projeto atual
  .\install.ps1 C:\meus\projetos\site # instala em outro projeto
  .\install.ps1 -Global               # instala para todos os seus projetos
  .\install.ps1 -Force                # atualiza uma instalacao existente
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

function Get-ScriptDir {
    if (-not $PSCommandPath) { Fail 'nao foi possivel determinar a pasta do script; rode-o a partir de um arquivo (.\install.ps1).' }
    return (Split-Path -Parent (Resolve-Link $PSCommandPath))
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

# Files in the destination that are not part of the payload (relative, forward slashes).
function Get-ExtraFiles([string]$Dir) {
    $prefix = $Dir.TrimEnd('\', '/') + [IO.Path]::DirectorySeparatorChar
    $extras = @()
    foreach ($f in @(Get-ChildItem -LiteralPath $Dir -Recurse -File -Force)) {
        $rel = $f.FullName.Substring($prefix.Length).Replace('\', '/')
        $top = $rel.Split('/')[0]
        $isPayload = ($Payload -ccontains $top) -and (Test-Path -LiteralPath (Join-Path $script:SrcDir $rel) -PathType Leaf)
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

function Invoke-Main {
    if ($Help) { Show-Usage | Out-Host; return 0 }

    if ($Rest -and @($Rest).Count -gt 0) {
        Warn ((Show-Usage) -join "`n")
        Fail "opcao ou argumento desconhecido: $(@($Rest) -join ' ') (veja -Help)"
    }
    if ($script:PathGiven -and [string]::IsNullOrWhiteSpace($Path)) {
        Fail 'a pasta do projeto esta vazia (argumento "")'
    }
    if ($Path -and $Path.StartsWith('-')) {
        Warn ((Show-Usage) -join "`n")
        Fail "opcao desconhecida: $Path (veja -Help; para pastas que comecam com '-' use .\$Path)"
    }
    if ($Global -and $Path) { Fail '-Global nao pode ser usado junto com uma pasta de projeto' }

    $script:SrcDir = Get-ScriptDir
    $srcDir = $script:SrcDir

    # Destination
    if ($Global) {
        $userHome = if ($env:USERPROFILE) { $env:USERPROFILE } else { $env:HOME }
        if (-not $userHome -or -not (Test-Path -LiteralPath $userHome -PathType Container)) {
            Fail 'pasta pessoal (USERPROFILE/HOME) nao definida ou inexistente'
        }
        $base = Resolve-Dir $userHome
    } else {
        if (-not $Path) { $Path = (Get-Location).Path }
        if (-not (Test-Path -LiteralPath $Path -PathType Container)) { Fail "a pasta do projeto nao existe: $Path" }
        $base = Resolve-Dir $Path
        if (Test-SamePath $base $srcDir) {
            Fail "o projeto de destino e o proprio repositorio da skill ($srcDir). Rode o instalador a partir de outro projeto: .\install.ps1 C:\caminho\do\projeto"
        }
    }
    $claudeDir = Join-Path $base '.claude'
    $skillsDir = Join-Path $claudeDir 'skills'
    $dest = Join-Path $skillsDir $SkillName

    # The clone itself must never be the destination (force/uninstall would delete it).
    if (Test-Exists $dest) {
        $realDest = [IO.Path]::GetFullPath((Resolve-Link $dest))
        if (Test-SamePath $realDest $srcDir) {
            Fail "a origem e o destino sao a mesma pasta; a skill ja esta instalada neste local ($dest)"
        }
        if (Test-Inside $srcDir $realDest) {
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

    # Validate the source (must be a full clone)
    foreach ($item in $Required) {
        if (-not (Test-Path -LiteralPath (Join-Path $srcDir $item))) {
            Fail "'$item' nao encontrado em $srcDir. Rode este script a partir de um clone completo do repositorio."
        }
    }

    # Existing install
    $exists = Test-Exists $dest
    if ($exists) {
        if (-not $Force) {
            $msg = "A skill $SkillName ja existe em: $dest"
            if (Test-Path -LiteralPath $dest -PathType Container) {
                $names = (Get-ChildItem -LiteralPath $dest -Force | ForEach-Object { $_.Name }) -join ' '
                $msg += "`n  $(Count-Files $dest) arquivo(s); conteudo: $names"
            }
            $msg += "`nUse -Force para substituir (ou -Uninstall para remover)."
            Fail $msg 2 -NoPrefix
        }
        if (-not (Test-OurSkill $dest)) {
            Fail "$dest existe mas nao parece ser a skill $SkillName. Nada foi alterado; remova manualmente se quiser substituir."
        }
        Write-ExtrasWarning $dest
    }

    if ($DryRun) {
        Write-Host "[dry-run] instalaria em $dest"
        foreach ($item in $Payload) {
            if (Test-Path -LiteralPath (Join-Path $srcDir $item)) { Write-Host "[dry-run]   copiaria $item" }
        }
        if ($exists) { Write-Host '[dry-run]   substituiria a instalacao existente (-Force)' }
        return 0
    }

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

    Write-Host "Instalado em: $dest ($(Count-Files $dest) arquivos)"
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

try {
    $code = @(Invoke-Main)[-1]
    exit $code
} catch {
    if ($null -ne $script:ExitCode) { exit $script:ExitCode }
    [Console]::Error.WriteLine('Erro inesperado: ' + $_.Exception.Message)
    exit 1
}
