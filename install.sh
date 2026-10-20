#!/usr/bin/env bash
# Installer for the "malewicz-design" Claude Code skill (Linux, macOS, Git Bash, WSL).
# Keep this file and install.ps1 in sync (same payload, same flags, same messages).
#
# Two modes:
#   local  - run from a clone (SKILL.md + references/ next to this script).
#   remote - run piped (curl ... | bash), downloaded alone, or with --version/--ref:
#            downloads the GitHub archive of a tag/branch and installs from it.
#
# Exit codes: 0 ok, 1 usage/validation error, 2 already installed (use --force).
# Exit code 2 is reserved for "already installed": the EXIT trap turns any
# other status 2 (e.g. a tool failing) into 1.
#
# Safe to pipe: bash executes a piped script while it streams in, so a cut
# connection must never run a prefix of it. Therefore this file contains only
# constants and function definitions; the single last line calls main with an
# end marker, and main refuses to do anything when that marker is missing.
#
# Environment overrides (tests and forks): MALEWICZ_ARCHIVE_BASE, MALEWICZ_RAW_BASE.
# Only https:// bases get --proto '=https' --tlsv1.2; an http:// base is honoured
# solely because the caller set it explicitly through these variables.
#
# Download limits: archive <= 20 MB (curl --max-filesize plus a size check),
# <= 2000 entries, only regular files and directories. An uncompressed-size bomb
# inside a .tar.gz is bounded only by the 20 MB compressed cap and the entry count.

set -eu

SKILL_NAME="malewicz-design"
ARCHIVE_BASE=${MALEWICZ_ARCHIVE_BASE:-https://github.com/Maccena/Malewicz-Design}
RAW_BASE=${MALEWICZ_RAW_BASE:-https://raw.githubusercontent.com/Maccena/Malewicz-Design}
ARCHIVE_BASE=${ARCHIVE_BASE%/}
RAW_BASE=${RAW_BASE%/}
END_MARKER="END_OF_MALEWICZ_INSTALL"
MAX_ARCHIVE_BYTES=20000000
MAX_ENTRIES=2000

# PAYLOAD: the ONLY things copied into the skill folder (relative to the source
# folder; directories are copied recursively). Keep in sync with the $Payload
# variable in install.ps1. LICENSE is optional, the rest is required.
PAYLOAD="SKILL.md references LICENSE"
REQUIRED="SKILL.md references"

ALREADY=0   # set to 1 right before the legitimate "exit 2"
STAGE=""    # new version being prepared
OLD=""      # previous version renamed out during a swap
DEL=""      # folder renamed out during an uninstall
TMPD=""     # download/extract workspace (remote mode)
DEST=""
SWAPPED=0   # set to 1 once the new version is in place
GLOBAL=0; FORCE=0; UNINSTALL=0; DRYRUN=0; PROJECT=""; HAVE_PROJECT=0
HAVE_VERSION=0; VERSION_ARG=""; HAVE_REF=0; REF_ARG=""
LOCAL=0; SRC_DIR=""; SCRIPT_DIR=""; REF=""; NEW_VERSION="desconhecida"; LATEST_DERIVED=0
NOT_FOUND_HINT=""

warn() { printf '%s\n' "$*" >&2; }
die() { printf 'Erro: %s\n' "$*" >&2; exit 1; }

# rm -rf only for our own scratch names (never for an empty/short/unexpected value).
safe_rm() {
  case ${1:-} in
    */.malewicz-design.new.*|*/.malewicz-design.del.*|*/.malewicz-design.old.*) rm -rf -- "$1" 2>/dev/null ;;
    *) return 1 ;;
  esac
}
safe_rm_tmp() {
  case ${1:-} in
    /*/malewicz-design.??????) rm -rf -- "$1" 2>/dev/null ;;
    *) return 1 ;;
  esac
}

finish() {
  rc=$?
  safe_rm "$STAGE" || :
  safe_rm "$DEL" || :
  safe_rm_tmp "$TMPD" || :
  if [ -n "$OLD" ] && { [ -e "$OLD" ] || [ -L "$OLD" ]; }; then
    if [ "$SWAPPED" -eq 1 ]; then
      safe_rm "$OLD" || :                     # swap completed: drop the old version
    elif [ -n "$DEST" ] && [ ! -e "$DEST" ] && [ ! -L "$DEST" ]; then
      mv -- "$OLD" "$DEST" 2>/dev/null || warn "A instalacao antiga ficou em: $OLD"   # interrupted swap: restore
    else
      warn "A instalacao antiga ficou em: $OLD"
    fi
  fi
  if [ "$rc" -eq 2 ] && [ "$ALREADY" -ne 1 ]; then exit 1; fi
  exit "$rc"
}

usage() {
  cat <<USAGE
Instala a skill $SKILL_NAME no Claude Code.

Uso:
  ./install.sh [opcoes] [PASTA_DO_PROJETO]
  ./install.sh [opcoes] -- -pasta-que-comeca-com-hifen
  curl -fsSL $RAW_BASE/main/install.sh | bash
  curl -fsSL $RAW_BASE/main/install.sh | bash -s -- --global --force

Por padrao instala no projeto (PASTA_DO_PROJETO, ou o diretorio atual) em
<projeto>/.claude/skills/$SKILL_NAME
Dentro de um clone instala a copia local; fora dele (ou com --version/--ref)
baixa o pacote do GitHub (ultima versao por padrao).

Opcoes:
  --global         instala para o usuario em ~/.claude/skills/$SKILL_NAME
  --force          substitui uma instalacao existente (remove arquivos antigos)
  --uninstall      remove a skill instalada
  --dry-run        mostra o que seria feito, sem alterar nada
  --version X.Y.Z  instala essa versao (tag vX.Y.Z); modo remoto
  --ref NOME       instala de um branch ou tag (ex.: main); modo remoto
  -h, --help       mostra esta ajuda

Exemplos:
  ./install.sh                      # instala no projeto atual
  ./install.sh ~/meus/projetos/site # instala em outro projeto
  ./install.sh --global             # instala para todos os seus projetos
  ./install.sh --force              # atualiza uma instalacao existente
  ./install.sh --version 1.0.0      # baixa e instala a versao 1.0.0
  ./install.sh --uninstall          # remove do projeto atual
  ./install.sh --global --uninstall # remove da pasta pessoal

Codigos de saida: 0 sucesso, 1 erro de uso/validacao, 2 ja instalado (sem --force).
USAGE
}

set_project() {
  [ "$HAVE_PROJECT" -eq 0 ] || die "mais de uma pasta de projeto informada (veja --help)"
  [ -n "$1" ] || die "a pasta do projeto esta vazia (argumento \"\")"
  PROJECT=$1; HAVE_PROJECT=1
}

# X.Y.Z (digits only).
valid_semver() {
  case $1 in ''|*[!0-9.]*|.*|*.|*..*|*.*.*.*) return 1 ;; esac
  case $1 in *.*.*) return 0 ;; esac
  return 1
}

# X.Y.Z with an optional leading v (nothing else).
valid_version() { valid_semver "${1#v}"; }

# Branch/tag name: [A-Za-z0-9._/-]+, not starting with - or /, no "..".
valid_ref() {
  case $1 in ''|*[!A-Za-z0-9._/-]*|-*|/*|*..*) return 1 ;; esac
  return 0
}

# True if semver $1 is strictly lower than semver $2 (both validated).
ver_lt() {
  oldifs=$IFS; IFS=.
  set -- $1 $2
  IFS=$oldifs
  [ "$1" -lt "$4" ] && return 0
  [ "$1" -gt "$4" ] && return 1
  [ "$2" -lt "$5" ] && return 0
  [ "$2" -gt "$5" ] && return 1
  [ "$3" -lt "$6" ] && return 0
  return 1
}

count_files() { find "$1/." -type f | wc -l | tr -d ' '; }

# True if $1/SKILL.md has "name: malewicz-design" inside its first frontmatter
# block (between the first two --- lines). Case-sensitive; BOM and CRLF tolerated.
is_our_skill() {
  [ -f "$1/SKILL.md" ] || return 1
  LC_ALL=C awk -v name="$SKILL_NAME" -v bom="$(printf '\357\273\277')" '
    NR == 1 && substr($0, 1, 3) == bom { $0 = substr($0, 4) }
    { sub(/\r$/, "") }
    NR == 1 { if ($0 !~ /^---[ \t]*$/) exit; next }
    /^---[ \t]*$/ { closed = 1; exit }
    $0 ~ ("^name:[ \t]*(" name "|\"" name "\"|\047" name "\047)[ \t]*$") { found = 1 }
    END { exit ((closed && found) ? 0 : 1) }
  ' "$1/SKILL.md"
}

# Prints the version declared in the frontmatter of file $1, or "desconhecida".
# Only an indented line  "  version: X.Y.Z"  (optional quotes and leading v) inside
# the first frontmatter block counts. CRLF/BOM tolerated. Never fails.
read_version() {
  rv=""
  if [ -f "$1" ]; then
    rv=$(LC_ALL=C awk -v bom="$(printf '\357\273\277')" '
      NR == 1 && substr($0, 1, 3) == bom { $0 = substr($0, 4) }
      { sub(/\r$/, "") }
      NR == 1 { if ($0 !~ /^---[ \t]*$/) exit; next }
      /^---[ \t]*$/ { exit }
      {
        q = "[\"\047]"
        if ($0 ~ ("^[ \t]+version:[ \t]*" q "?v?[0-9]+\\.[0-9]+\\.[0-9]+" q "?[ \t]*$")) {
          s = $0
          sub(/^[ \t]+version:[ \t]*/, "", s)
          gsub(q, "", s); gsub(/[ \t]/, "", s); sub(/^v/, "", s)
          print s; exit
        }
      }
    ' "$1" 2>/dev/null) || rv=""
  fi
  printf '%s\n' "${rv:-desconhecida}"
}

# Files in the destination that are not part of the payload (relative paths).
# Without a source folder (remote uninstall) only the top-level names are compared.
list_extras() {
  find "$DEST/." \( -type f -o -type l \) | while IFS= read -r f; do
    rel=${f#"$DEST"/./}
    top=${rel%%/*}
    case " $PAYLOAD " in
      *" $top "*) if [ -z "$SRC_DIR" ] || [ -f "$SRC_DIR/$rel" ]; then continue; fi ;;
    esac
    printf '%s\n' "$rel"
  done
}

warn_extras() {
  extras=$(list_extras)
  [ -n "$extras" ] || return 0
  n=$(printf '%s\n' "$extras" | wc -l | tr -d ' ')
  {
    echo "Aviso: $n arquivo(s) que nao fazem parte da skill serao removidos de $DEST:"
    printf '%s\n' "$extras" | head -n 20 | sed 's/^/  /'
    [ "$n" -le 20 ] || echo "  ... e mais $((n - 20))"
  } >&2
}

# Remove leftovers of interrupted runs (exact name patterns only; dead pid or older than 1 day).
clean_stale() {
  for d in "$CLAUDE_DIR" "$SKILLS_DIR"; do
    [ -d "$d" ] || continue
    for p in "$d/.$SKILL_NAME.new."* "$d/.$SKILL_NAME.del."*; do
      [ -d "$p" ] && [ ! -L "$p" ] || continue
      pid=${p##*.}
      case $pid in ''|*[!0-9]*) continue ;; esac
      if kill -0 "$pid" 2>/dev/null && [ -z "$(find "$p" -prune -mtime +0 2>/dev/null)" ]; then continue; fi
      safe_rm "$p" || :
    done
  done
}

# ---------------------------------------------------------------- remote mode

make_tmp() {
  if [ -z "$TMPD" ]; then
    TMPD=$(mktemp -d "${TMPDIR:-/tmp}/$SKILL_NAME.XXXXXX") || { TMPD=""; die "nao foi possivel criar uma pasta temporaria"; }
  fi
}

# curl_get URL OUT MAXTIME: returns curl's exit status. -q first: ignore any ~/.curlrc.
curl_get() {
  case $1 in
    https://*) curl -q -fsSL --proto '=https' --tlsv1.2 --retry 2 --connect-timeout 15 --max-time "$3" \
                 --max-filesize "$MAX_ARCHIVE_BYTES" -o "$2" "$1" ;;
    *)         curl -q -fsSL --retry 2 --connect-timeout 15 --max-time "$3" \
                 --max-filesize "$MAX_ARCHIVE_BYTES" -o "$2" "$1" ;;
  esac
}

# fetch_file URL OUT MAXTIME: like curl_get but aborts with a friendly message.
fetch_file() {
  frc=0
  curl_get "$1" "$2" "$3" || frc=$?
  [ "$frc" -eq 0 ] && return 0
  case $frc in
    22) if [ -n "$NOT_FOUND_HINT" ]; then die "$NOT_FOUND_HINT"; fi
        die "o servidor respondeu com erro HTTP ao baixar $1 (o repositorio ou a tag pode nao existir, ou o repositorio pode ser privado)" ;;
    28) die "tempo esgotado ao baixar $1" ;;
    63) die "o arquivo de $1 excede o limite de 20 MB" ;;
    *)  die "falha de rede ao baixar $1 (curl codigo $frc)" ;;
  esac
}

# Decides REF (what to download) and NEW_VERSION (what it will announce).
resolve_remote() {
  command -v curl >/dev/null 2>&1 || die "curl nao encontrado; instale o curl ou use um clone do repositorio"
  command -v tar >/dev/null 2>&1 || die "tar nao encontrado; instale o tar ou use um clone do repositorio"
  if [ -n "${MALEWICZ_RAW_BASE:-}" ] || [ -n "${MALEWICZ_ARCHIVE_BASE:-}" ]; then
    warn "Aviso: usando base alternativa (raw: $RAW_BASE; arquivo: $ARCHIVE_BASE)"
  fi
  make_tmp
  if [ "$HAVE_VERSION" -eq 1 ]; then
    NEW_VERSION=${VERSION_ARG#v}
    REF=v$NEW_VERSION
  elif [ "$HAVE_REF" -eq 1 ]; then
    REF=$REF_ARG
    NEW_VERSION=desconhecida
    if curl_get "$RAW_BASE/$REF/SKILL.md" "$TMPD/remote-SKILL.md" 30 2>/dev/null; then
      NEW_VERSION=$(read_version "$TMPD/remote-SKILL.md")
    fi
  else
    fetch_file "$RAW_BASE/main/SKILL.md" "$TMPD/remote-SKILL.md" 30
    NEW_VERSION=$(read_version "$TMPD/remote-SKILL.md")
    valid_semver "$NEW_VERSION" || die "nao foi possivel descobrir a ultima versao (campo 'version:' ausente ou invalido em $RAW_BASE/main/SKILL.md). Use --version X.Y.Z ou --ref main."
    REF=v$NEW_VERSION
    LATEST_DERIVED=1
  fi
}

# Checks the extracted folder $1 before anything is installed from it.
validate_payload() {
  [ -f "$1/SKILL.md" ] || die "o pacote baixado nao tem SKILL.md"
  is_our_skill "$1" || die "o SKILL.md do pacote baixado nao tem 'name: $SKILL_NAME' no frontmatter"
  [ -d "$1/references" ] && [ -n "$(find "$1/references" -type f | head -n 1)" ] || die "o pacote baixado nao tem references/ (ou esta vazia)"
  links=$(grep -Eo 'references/[A-Za-z0-9._/-]+\.md' "$1/SKILL.md" | sort -u) || links=""
  missing=""
  for p in $links; do
    case $p in
      *..*|/*) die "o SKILL.md do pacote contem um link inseguro para references/ ($p); nada foi instalado" ;;
    esac
    [ -f "$1/$p" ] || missing="$missing$p "
  done
  [ -z "$missing" ] || die "o SKILL.md do pacote referencia arquivos que nao existem no pacote: $missing"
}

# Downloads and extracts the archive of $REF into $TMPD; sets SRC_DIR.
download_source() {
  make_tmp
  arc=$TMPD/source.tar.gz
  x=$TMPD/x
  mkdir "$x" || die "nao foi possivel criar uma pasta temporaria"
  if [ "$LATEST_DERIVED" -eq 1 ]; then
    NOT_FOUND_HINT="a ultima versao declarada e $NEW_VERSION, mas a tag $REF ainda nao foi publicada; tente --version <versao anterior> ou --ref main"
  fi
  fetch_file "$ARCHIVE_BASE/archive/$REF.tar.gz" "$arc" 120
  NOT_FOUND_HINT=""
  [ "$(wc -c < "$arc" | tr -d ' ')" -le "$MAX_ARCHIVE_BYTES" ] || die "o pacote baixado excede o limite de 20 MB"
  tar -tzf "$arc" >"$TMPD/list.txt" 2>/dev/null || die "o arquivo baixado nao e um tar.gz valido"
  [ "$(wc -l < "$TMPD/list.txt" | tr -d ' ')" -le "$MAX_ENTRIES" ] || die "o pacote baixado tem entradas demais (limite $MAX_ENTRIES)"
  if grep -Eq '(^|/)\.\.(/|$)|^/' "$TMPD/list.txt"; then
    die "o pacote baixado contem caminhos inseguros (.. ou absolutos); nada foi instalado"
  fi
  tar -tvzf "$arc" >"$TMPD/listv.txt" 2>/dev/null || die "o arquivo baixado nao e um tar.gz valido"
  # Only regular files (-) and directories (d): no links, devices, fifos, sockets.
  if grep -q -v '^[-d]' "$TMPD/listv.txt"; then
    die "o pacote baixado contem entradas que nao sao arquivos nem pastas (links, dispositivos); nada foi instalado"
  fi
  tar -xzf "$arc" -C "$x" || die "falha ao extrair o pacote baixado"
  [ -z "$(find "$x" ! -type f ! -type d)" ] || die "o pacote baixado contem entradas que nao sao arquivos nem pastas; nada foi instalado"
  [ "$(ls -A "$x" | wc -l | tr -d ' ')" -eq 1 ] || die "o pacote baixado tem estrutura inesperada (esperada uma unica pasta raiz)"
  top=$(ls -A "$x")
  [ -d "$x/$top" ] || die "o pacote baixado tem estrutura inesperada (esperada uma unica pasta raiz)"
  SRC_DIR=$x/$top
  validate_payload "$SRC_DIR"
  got=$(read_version "$SRC_DIR/SKILL.md")
  [ "$got" = desconhecida ] || NEW_VERSION=$got
}

# ------------------------------------------------------------------------ main

main() {
  trap finish EXIT
  trap 'exit 130' INT
  trap 'exit 143' TERM

  # The last argument must be our end marker: otherwise the script was cut short.
  [ $# -ge 1 ] || die "o script esta incompleto (download interrompido?); nada foi feito"
  n=$#; i=0
  for a in "$@"; do i=$((i + 1)); if [ "$i" -eq "$n" ]; then last=$a; fi; done
  [ "$last" = "$END_MARKER" ] || die "o script esta incompleto (download interrompido?); nada foi feito"
  i=0
  while [ "$i" -lt $((n - 1)) ]; do set -- "$@" "$1"; shift; i=$((i + 1)); done
  shift

  while [ $# -gt 0 ]; do
    case $1 in
      --global)    GLOBAL=1 ;;
      --force)     FORCE=1 ;;
      --uninstall) UNINSTALL=1 ;;
      --dry-run)   DRYRUN=1 ;;
      --version)   [ $# -ge 2 ] || die "--version exige um valor (ex.: --version 1.0.0)"
                   HAVE_VERSION=1; VERSION_ARG=$2; shift ;;
      --version=*) HAVE_VERSION=1; VERSION_ARG=${1#--version=} ;;
      --ref)       [ $# -ge 2 ] || die "--ref exige um valor (ex.: --ref main)"
                   HAVE_REF=1; REF_ARG=$2; shift ;;
      --ref=*)     HAVE_REF=1; REF_ARG=${1#--ref=} ;;
      -h|--help)   usage; exit 0 ;;
      --)          shift; break ;;
      -?*)         die "opcao desconhecida: $1 (veja --help)" ;;
      *)           set_project "$1" ;;
    esac
    shift
  done
  # Anything after "--" is positional.
  while [ $# -gt 0 ]; do set_project "$1"; shift; done

  [ "$GLOBAL" -eq 0 ] || [ "$HAVE_PROJECT" -eq 0 ] || die "--global nao pode ser usado junto com uma pasta de projeto"
  [ "$HAVE_VERSION" -eq 0 ] || [ "$HAVE_REF" -eq 0 ] || die "--version e --ref nao podem ser usados juntos"
  if [ "$HAVE_VERSION" -eq 1 ]; then
    valid_version "$VERSION_ARG" || die "versao invalida: use X.Y.Z (ex.: 1.0.0)"
  fi
  if [ "$HAVE_REF" -eq 1 ]; then
    valid_ref "$REF_ARG" || die "ref invalido: use apenas letras, numeros, . _ / - (sem comecar com - ou /, sem '..')"
  fi

  if [ "$(id -u 2>/dev/null || echo 1)" = 0 ]; then
    warn "Aviso: executando como root; os arquivos instalados serao de root (HOME=${HOME:-?})."
  fi

  # Locate this script (empty when piped: $0 is then just "bash"/"sh"), following symlinks.
  # (A piped bash reports its own name, e.g. "bash", in both BASH_SOURCE and $0: never a script path.)
  src=${BASH_SOURCE:-}
  [ -n "$src" ] || src=$0
  case $src in
    bash|sh|dash|zsh|ksh|ash|*/bash|*/sh|*/dash|*/zsh|*/ksh|*/ash|-*) src="" ;;
  esac
  if [ -n "$src" ] && [ -f "$src" ]; then
    while [ -L "$src" ]; do
      dir=$(cd -P -- "$(dirname -- "$src")" && pwd)
      src=$(readlink "$src")
      case $src in /*) ;; *) src=$dir/$src ;; esac
    done
    SCRIPT_DIR=$(cd -P -- "$(dirname -- "$src")" && pwd) || SCRIPT_DIR=""
  fi

  # Local mode: payload next to the script and no explicit --version/--ref.
  if [ -n "$SCRIPT_DIR" ] && [ -e "$SCRIPT_DIR/SKILL.md" ] && [ -e "$SCRIPT_DIR/references" ] \
     && [ "$HAVE_VERSION" -eq 0 ] && [ "$HAVE_REF" -eq 0 ]; then
    LOCAL=1
    SRC_DIR=$SCRIPT_DIR
  fi

  # Destination
  if [ "$GLOBAL" -eq 1 ]; then
    [ -n "${HOME:-}" ] && [ -d "$HOME" ] || die "variavel HOME nao definida ou pasta inexistente"
    BASE=$(cd -P -- "$HOME" && pwd) || die "nao foi possivel acessar HOME: $HOME"
  else
    [ "$HAVE_PROJECT" -eq 1 ] || PROJECT=$(pwd)
    [ -d "$PROJECT" ] || die "a pasta do projeto nao existe: $PROJECT"
    BASE=$(cd -P -- "$PROJECT" && pwd) || die "nao foi possivel acessar a pasta do projeto: $PROJECT"
    if [ "$LOCAL" -eq 1 ] && [ "$BASE" = "$SCRIPT_DIR" ]; then
      die "o projeto de destino e o proprio repositorio da skill ($SCRIPT_DIR). Rode o instalador a partir de outro projeto: ./install.sh /caminho/do/projeto"
    fi
    if [ -n "${WSL_DISTRO_NAME:-}" ]; then
      case $BASE in
        /mnt/[a-zA-Z]|/mnt/[a-zA-Z]/*)
          warn "Nota: voce esta no WSL (Linux) instalando em uma pasta do Windows ($BASE)."
          warn "Se o Claude Code roda no Windows, prefira o PowerShell: irm $RAW_BASE/main/install.ps1 | iex" ;;
      esac
    fi
  fi
  CLAUDE_DIR=$BASE/.claude
  SKILLS_DIR=$CLAUDE_DIR/skills
  DEST=$SKILLS_DIR/$SKILL_NAME

  # The clone itself must never be the destination (force/uninstall would delete it).
  if [ -n "$SCRIPT_DIR" ] && [ -e "$DEST" ]; then
    REAL=$(cd -P -- "$DEST" 2>/dev/null && pwd) || REAL=""
    if [ "$DEST" -ef "$SCRIPT_DIR" ] || [ "$REAL" = "$SCRIPT_DIR" ]; then
      die "a origem e o destino sao a mesma pasta; a skill ja esta instalada neste local ($DEST)"
    fi
    if [ -n "$REAL" ]; then
      case "$SCRIPT_DIR/" in "$REAL"/*) die "este script esta dentro da pasta de destino ($DEST); a origem e o destino se sobrepoem" ;; esac
    fi
  fi

  # ---------------------------------------------------------------- uninstall
  if [ "$UNINSTALL" -eq 1 ]; then
    if [ ! -e "$DEST" ] && [ ! -L "$DEST" ]; then
      echo "Nada para remover: $SKILL_NAME nao esta instalada em $DEST"
      exit 0
    fi
    is_our_skill "$DEST" || die "$DEST nao parece ser a skill $SKILL_NAME (SKILL.md ausente ou com outro 'name:'). Nada foi removido."
    warn_extras
    if [ "$DRYRUN" -eq 1 ]; then
      echo "[dry-run] removeria $DEST"
      exit 0
    fi
    clean_stale
    # Rename first (atomic), then delete: the skill is gone from the skills folder even if the delete fails.
    DEL=$CLAUDE_DIR/.$SKILL_NAME.del.$$
    mv -- "$DEST" "$DEL" || { DEL=""; die "nao foi possivel remover $DEST (arquivos em uso?). Nada foi alterado."; }
    safe_rm "$DEL" || warn "Aviso: a skill foi removida, mas sobrou lixo em $DEL (apague manualmente)."
    [ ! -e "$DEL" ] || DEL=""
    echo "Removido: $DEST"
    exit 0
  fi

  # ------------------------------------------------------------------ install
  if [ "$LOCAL" -eq 1 ]; then
    for item in $REQUIRED; do
      [ -e "$SRC_DIR/$item" ] || die "'$item' nao encontrado em $SRC_DIR. Rode este script a partir de um clone completo do repositorio."
    done
    NEW_VERSION=$(read_version "$SRC_DIR/SKILL.md")
  else
    resolve_remote
  fi

  EXISTS=0
  if [ -e "$DEST" ] || [ -L "$DEST" ]; then EXISTS=1; fi
  OLD_VERSION="desconhecida"
  [ "$EXISTS" -eq 0 ] || OLD_VERSION=$(read_version "$DEST/SKILL.md")

  if [ "$EXISTS" -eq 1 ] && [ "$FORCE" -eq 0 ]; then
    {
      echo "A skill $SKILL_NAME ja existe em: $DEST"
      if [ "$OLD_VERSION" = "$NEW_VERSION" ] && [ "$NEW_VERSION" != desconhecida ]; then
        echo "  ja esta na versao $NEW_VERSION (use --force para reinstalar)"
      elif [ "$HAVE_VERSION" -eq 1 ]; then
        echo "  versao instalada: $OLD_VERSION; versao solicitada: $NEW_VERSION"
      else
        echo "  versao instalada: $OLD_VERSION; versao a instalar: $NEW_VERSION"
      fi
      if [ -d "$DEST" ]; then
        echo "  $(count_files "$DEST") arquivo(s); conteudo: $(ls -A "$DEST" | tr '\n' ' ')"
      fi
      echo "Use --force para substituir (ou --uninstall para remover)."
    } >&2
    ALREADY=1
    exit 2
  fi

  if [ "$LOCAL" -eq 0 ]; then
    download_source
  fi

  if [ "$EXISTS" -eq 1 ]; then
    is_our_skill "$DEST" || die "$DEST existe mas nao parece ser a skill $SKILL_NAME. Nada foi alterado; remova manualmente se quiser substituir."
    warn_extras
    OLD_VERSION=$(read_version "$DEST/SKILL.md")
  fi

  if [ "$EXISTS" -eq 0 ]; then
    ANNOUNCE="instalando $NEW_VERSION"
  elif [ "$OLD_VERSION" = "$NEW_VERSION" ] && [ "$NEW_VERSION" != desconhecida ]; then
    ANNOUNCE="ja esta na versao $NEW_VERSION - reinstalando"
  else
    ANNOUNCE="instalando $NEW_VERSION (substituindo $OLD_VERSION)"
    if valid_semver "$NEW_VERSION" && valid_semver "$OLD_VERSION" && ver_lt "$NEW_VERSION" "$OLD_VERSION"; then
      ANNOUNCE="$ANNOUNCE (downgrade)"
    fi
  fi

  echo "Destino: $DEST"
  if [ "$DRYRUN" -eq 1 ]; then
    echo "[dry-run] $ANNOUNCE"
    echo "[dry-run] instalaria em $DEST"
    for item in $PAYLOAD; do
      if [ -e "$SRC_DIR/$item" ]; then echo "[dry-run]   copiaria $item"; fi
    done
    [ "$EXISTS" -eq 0 ] || echo "[dry-run]   substituiria a instalacao existente (--force)"
    exit 0
  fi
  echo "$ANNOUNCE"

  clean_stale
  mkdir -p "$SKILLS_DIR" || die "nao foi possivel criar $SKILLS_DIR"
  # Staging lives outside the skills folder so it is never scanned as a skill.
  STAGE=$CLAUDE_DIR/.$SKILL_NAME.new.$$
  mkdir "$STAGE" || { STAGE=""; die "nao foi possivel criar a pasta temporaria em $CLAUDE_DIR"; }

  for item in $PAYLOAD; do
    [ -e "$SRC_DIR/$item" ] || continue
    cp -R "$SRC_DIR/$item" "$STAGE/" || die "falha ao copiar $item"
  done
  # Normalise permissions (archives may carry odd modes): files 644, directories 755.
  find "$STAGE" -type d -exec chmod 755 {} + || die "falha ao ajustar permissoes"
  find "$STAGE" -type f -exec chmod 644 {} + || die "falha ao ajustar permissoes"

  # Swap: old out, new in; the old copy is deleted only after the new one is in place.
  if [ -e "$DEST" ] || [ -L "$DEST" ]; then
    OLD=$CLAUDE_DIR/.$SKILL_NAME.del.$$
    mv -- "$DEST" "$OLD" || { OLD=""; die "nao foi possivel substituir $DEST (arquivos em uso?). A instalacao antiga foi mantida."; }
  fi
  if ! mv -- "$STAGE" "$DEST"; then
    case $DEST in */.claude/skills/$SKILL_NAME) rm -rf -- "$DEST" 2>/dev/null || : ;; esac   # partial result, if any
    if [ -n "$OLD" ] && [ ! -e "$DEST" ] && mv -- "$OLD" "$DEST"; then OLD=""; fi
    die "falha ao colocar a nova versao em $DEST (a instalacao antiga foi restaurada, se existia)"
  fi
  STAGE=""; SWAPPED=1
  if [ -n "$OLD" ]; then
    safe_rm "$OLD" || warn "Aviso: a versao antiga sobrou em $OLD (apague manualmente)."
    [ -e "$OLD" ] || OLD=""
  fi

  echo "Instalado em: $DEST ($(count_files "$DEST") arquivos) - versao $NEW_VERSION"
  echo
  echo "Proximo passo: abra o Claude Code neste projeto e digite /$SKILL_NAME"
  echo "(ou apenas peca uma landing page / revisao de UI)."
  echo "O Claude Code detecta novas pastas de skills automaticamente, mas se a pasta"
  echo ".claude/skills nao existia quando a sessao comecou, use /reload-skills ou reinicie."
  if [ "$GLOBAL" -eq 0 ]; then
    echo
    echo "Para compartilhar com o time, versione a skill no projeto:"
    echo "  git add .claude/skills/$SKILL_NAME"
  fi
}

main "$@" END_OF_MALEWICZ_INSTALL
