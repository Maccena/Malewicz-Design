#!/usr/bin/env bash
# Installer for the "malewicz-design" Claude Code skill (Linux, macOS, Git Bash).
# Keep this file and install.ps1 in sync (same payload, same flags, same messages).
#
# Exit codes: 0 ok, 1 usage/validation error, 2 already installed (use --force).
# Exit code 2 is reserved for "already installed": the EXIT trap turns any
# other status 2 (e.g. a tool failing) into 1.

set -eu

SKILL_NAME="malewicz-design"

# PAYLOAD: the ONLY things copied into the skill folder (relative to this
# script's directory; directories are copied recursively). Keep in sync with
# the $Payload variable in install.ps1. LICENSE is optional, the rest is required.
PAYLOAD="SKILL.md references LICENSE"
REQUIRED="SKILL.md references"

ALREADY=0   # set to 1 right before the legitimate "exit 2"
STAGE=""    # new version being prepared
OLD=""      # previous version renamed out during a swap
DEL=""      # folder renamed out during an uninstall
SWAPPED=0   # set to 1 once the new version is in place
DEST=""

warn() { printf '%s\n' "$*" >&2; }
die() { printf 'Erro: %s\n' "$*" >&2; exit 1; }

finish() {
  rc=$?
  [ -z "$STAGE" ] || rm -rf "$STAGE" 2>/dev/null || :
  [ -z "$DEL" ] || rm -rf "$DEL" 2>/dev/null || :
  if [ -n "$OLD" ] && { [ -e "$OLD" ] || [ -L "$OLD" ]; }; then
    if [ "$SWAPPED" -eq 1 ]; then
      rm -rf "$OLD" 2>/dev/null || :          # swap completed: drop the old version
    elif [ ! -e "$DEST" ] && [ ! -L "$DEST" ]; then
      mv -- "$OLD" "$DEST" 2>/dev/null || warn "A instalacao antiga ficou em: $OLD"   # interrupted swap: restore
    else
      warn "A instalacao antiga ficou em: $OLD"
    fi
  fi
  if [ "$rc" -eq 2 ] && [ "$ALREADY" -ne 1 ]; then exit 1; fi
  exit "$rc"
}
trap finish EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

usage() {
  cat <<USAGE
Instala a skill $SKILL_NAME no Claude Code.

Uso:
  ./install.sh [opcoes] [PASTA_DO_PROJETO]
  ./install.sh [opcoes] -- -pasta-que-comeca-com-hifen

Por padrao instala no projeto (PASTA_DO_PROJETO, ou o diretorio atual) em
<projeto>/.claude/skills/$SKILL_NAME

Opcoes:
  --global      instala para o usuario em ~/.claude/skills/$SKILL_NAME
  --force       substitui uma instalacao existente (remove arquivos antigos)
  --uninstall   remove a skill instalada
  --dry-run     mostra o que seria feito, sem alterar nada
  -h, --help    mostra esta ajuda

Exemplos:
  ./install.sh                      # instala no projeto atual
  ./install.sh ~/meus/projetos/site # instala em outro projeto
  ./install.sh --global             # instala para todos os seus projetos
  ./install.sh --force              # atualiza uma instalacao existente
  ./install.sh --uninstall          # remove do projeto atual
  ./install.sh --global --uninstall # remove da pasta pessoal

Codigos de saida: 0 sucesso, 1 erro de uso/validacao, 2 ja instalado (sem --force).
USAGE
}

GLOBAL=0; FORCE=0; UNINSTALL=0; DRYRUN=0; PROJECT=""; HAVE_PROJECT=0

set_project() {
  [ "$HAVE_PROJECT" -eq 0 ] || die "mais de uma pasta de projeto informada (veja --help)"
  [ -n "$1" ] || die "a pasta do projeto esta vazia (argumento \"\")"
  PROJECT=$1; HAVE_PROJECT=1
}

while [ $# -gt 0 ]; do
  case $1 in
    --global)    GLOBAL=1 ;;
    --force)     FORCE=1 ;;
    --uninstall) UNINSTALL=1 ;;
    --dry-run)   DRYRUN=1 ;;
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

# Resolve the directory of this script, following symlinks (portable: no readlink -f).
src=$0
while [ -L "$src" ]; do
  dir=$(cd -P -- "$(dirname -- "$src")" && pwd)
  src=$(readlink "$src")
  case $src in /*) ;; *) src=$dir/$src ;; esac
done
SRC_DIR=$(cd -P -- "$(dirname -- "$src")" && pwd) || die "nao foi possivel resolver a pasta do script"

# Destination
if [ "$GLOBAL" -eq 1 ]; then
  [ -n "${HOME:-}" ] && [ -d "$HOME" ] || die "variavel HOME nao definida ou pasta inexistente"
  BASE=$(cd -P -- "$HOME" && pwd) || die "nao foi possivel acessar HOME: $HOME"
else
  [ "$HAVE_PROJECT" -eq 1 ] || PROJECT=$(pwd)
  [ -d "$PROJECT" ] || die "a pasta do projeto nao existe: $PROJECT"
  BASE=$(cd -P -- "$PROJECT" && pwd) || die "nao foi possivel acessar a pasta do projeto: $PROJECT"
  [ "$BASE" != "$SRC_DIR" ] || die "o projeto de destino e o proprio repositorio da skill ($SRC_DIR). Rode o instalador a partir de outro projeto: ./install.sh /caminho/do/projeto"
fi
CLAUDE_DIR=$BASE/.claude
SKILLS_DIR=$CLAUDE_DIR/skills
DEST=$SKILLS_DIR/$SKILL_NAME

# The clone itself must never be the destination (force/uninstall would delete it).
if [ -e "$DEST" ]; then
  REAL=$(cd -P -- "$DEST" 2>/dev/null && pwd) || REAL=""
  if [ "$DEST" -ef "$SRC_DIR" ] || [ "$REAL" = "$SRC_DIR" ]; then
    die "a origem e o destino sao a mesma pasta; a skill ja esta instalada neste local ($DEST)"
  fi
  if [ -n "$REAL" ]; then
    case "$SRC_DIR/" in "$REAL"/*) die "este script esta dentro da pasta de destino ($DEST); a origem e o destino se sobrepoem" ;; esac
  fi
fi

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

# Files in the destination that are not part of the payload (relative paths).
list_extras() {
  find "$DEST/." \( -type f -o -type l \) | while IFS= read -r f; do
    rel=${f#"$DEST"/./}
    top=${rel%%/*}
    case " $PAYLOAD " in *" $top "*) [ -f "$SRC_DIR/$rel" ] && continue ;; esac
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
      rm -rf "$p" 2>/dev/null || :
    done
  done
}

# Uninstall
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
  rm -rf "$DEL" 2>/dev/null || warn "Aviso: a skill foi removida, mas sobrou lixo em $DEL (apague manualmente)."
  [ ! -e "$DEL" ] || DEL=""
  echo "Removido: $DEST"
  exit 0
fi

# Validate the source (must be a full clone)
for item in $REQUIRED; do
  [ -e "$SRC_DIR/$item" ] || die "'$item' nao encontrado em $SRC_DIR. Rode este script a partir de um clone completo do repositorio."
done

# Existing install
if [ -e "$DEST" ] || [ -L "$DEST" ]; then
  if [ "$FORCE" -eq 0 ]; then
    {
      echo "A skill $SKILL_NAME ja existe em: $DEST"
      if [ -d "$DEST" ]; then
        echo "  $(count_files "$DEST") arquivo(s); conteudo: $(ls -A "$DEST" | tr '\n' ' ')"
      fi
      echo "Use --force para substituir (ou --uninstall para remover)."
    } >&2
    ALREADY=1
    exit 2
  fi
  is_our_skill "$DEST" || die "$DEST existe mas nao parece ser a skill $SKILL_NAME. Nada foi alterado; remova manualmente se quiser substituir."
  warn_extras
fi

# Install
if [ "$DRYRUN" -eq 1 ]; then
  echo "[dry-run] instalaria em $DEST"
  for item in $PAYLOAD; do
    [ -e "$SRC_DIR/$item" ] && echo "[dry-run]   copiaria $item"
  done
  [ ! -e "$DEST" ] || echo "[dry-run]   substituiria a instalacao existente (--force)"
  exit 0
fi

clean_stale
mkdir -p "$SKILLS_DIR" || die "nao foi possivel criar $SKILLS_DIR"
# Staging lives outside the skills folder so it is never scanned as a skill.
STAGE=$CLAUDE_DIR/.$SKILL_NAME.new.$$
mkdir "$STAGE" || { STAGE=""; die "nao foi possivel criar a pasta temporaria em $CLAUDE_DIR"; }

for item in $PAYLOAD; do
  [ -e "$SRC_DIR/$item" ] || continue
  cp -R "$SRC_DIR/$item" "$STAGE/" || die "falha ao copiar $item"
done

# Swap: old out, new in; the old copy is deleted only after the new one is in place.
if [ -e "$DEST" ] || [ -L "$DEST" ]; then
  OLD=$CLAUDE_DIR/.$SKILL_NAME.del.$$
  mv -- "$DEST" "$OLD" || { OLD=""; die "nao foi possivel substituir $DEST (arquivos em uso?). A instalacao antiga foi mantida."; }
fi
if ! mv -- "$STAGE" "$DEST"; then
  rm -rf "$DEST" 2>/dev/null || :     # partial result, if any
  if [ -n "$OLD" ] && [ ! -e "$DEST" ] && mv -- "$OLD" "$DEST"; then OLD=""; fi
  die "falha ao colocar a nova versao em $DEST (a instalacao antiga foi restaurada, se existia)"
fi
STAGE=""; SWAPPED=1
if [ -n "$OLD" ]; then
  rm -rf "$OLD" 2>/dev/null || warn "Aviso: a versao antiga sobrou em $OLD (apague manualmente)."
  [ -e "$OLD" ] || OLD=""
fi

echo "Instalado em: $DEST ($(count_files "$DEST") arquivos)"
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
