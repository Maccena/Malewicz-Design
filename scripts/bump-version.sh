#!/usr/bin/env bash
#
# bump-version.sh - set the release version of the skill.
#
# Maintainer tooling: the installers do not copy scripts/ into a project.
#
# The version lives in one place, `metadata.version` in the SKILL.md frontmatter. The installers
# read it to announce "installing X (replacing Y)" and to resolve "latest" (they fetch SKILL.md
# from main, then download the git tag v<version>), so a release is only complete once the tag
# v<version> exists on GitHub.
#
# Usage:  scripts/bump-version.sh 1.1.0
#
# Write the CHANGELOG.md entry first: this script refuses to run unless CHANGELOG.md already has
# a "## <new-version>" heading, so a release never goes out without notes. It also refuses
# anything that is not bare MAJOR.MINOR.PATCH or not strictly greater than the current version.
# It edits SKILL.md and prints the git commands for the commit and the tag; it never commits,
# tags or pushes by itself.
#
# Dependencies: bash, sed, grep, awk, mktemp, mv.
#
set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_FILE="$ROOT/SKILL.md"
CHANGELOG="$ROOT/CHANGELOG.md"

die() { printf 'bump-version: %s\n' "$1" >&2; exit "${2:-1}"; }

[ "$#" -eq 1 ] || die "usage: scripts/bump-version.sh <MAJOR.MINOR.PATCH>" 2
NEW="${1#v}"
printf '%s' "$NEW" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+$' \
  || die "'$1' is not a bare MAJOR.MINOR.PATCH version" 2

[ -f "$SKILL_FILE" ] || die "SKILL.md not found at $SKILL_FILE"
[ -f "$CHANGELOG" ] || die "CHANGELOG.md not found at $CHANGELOG"

# Line number of the `version:` key inside the frontmatter (between the first two --- lines).
# Bounded that way so a version mentioned in the prose below can never be edited.
LINE="$(awk '
  { sub(/\r$/, "") }
  NR == 1 && $0 != "---" { exit }
  NR > 1 && $0 == "---" { exit }
  NR > 1 && /^[[:space:]]+version:[[:space:]]*/ { print NR; exit }
' "$SKILL_FILE")"
[ -n "$LINE" ] || die "no 'version:' key found inside the SKILL.md frontmatter (metadata.version)"

CURRENT="$(sed -n "${LINE}p" "$SKILL_FILE" | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' | head -n 1 || true)"
[ -n "$CURRENT" ] || die "could not read the current version on SKILL.md line $LINE"

# Strictly greater: compare the three numeric fields.
IFS=. read -r c1 c2 c3 <<EOV
$CURRENT
EOV
IFS=. read -r n1 n2 n3 <<EOV
$NEW
EOV
greater=0
if [ "$n1" -gt "$c1" ]; then greater=1
elif [ "$n1" -eq "$c1" ] && [ "$n2" -gt "$c2" ]; then greater=1
elif [ "$n1" -eq "$c1" ] && [ "$n2" -eq "$c2" ] && [ "$n3" -gt "$c3" ]; then greater=1
fi
[ "$greater" -eq 1 ] || die "new version $NEW must be greater than the current $CURRENT"

grep -Eq "^## \[?${NEW//./\.}\]?([[:space:]]|$)" "$CHANGELOG" \
  || die "CHANGELOG.md has no '## $NEW' heading: write the release notes first"

TMP="$(mktemp "${TMPDIR:-/tmp}/bump.XXXXXX")"
trap 'rm -f "$TMP"' EXIT
# Replace only the number on that line, keeping the quoting and indentation as they are.
sed "${LINE}s/${CURRENT//./\.}/$NEW/" "$SKILL_FILE" > "$TMP"
grep -Eq "version:[[:space:]]*\"?${NEW//./\.}" <(sed -n "${LINE}p" "$TMP") \
  || die "failed to rewrite the version line; SKILL.md left untouched"
cat "$TMP" > "$SKILL_FILE"

printf 'SKILL.md: %s -> %s\n\n' "$CURRENT" "$NEW"
cat <<MSG
Next steps (nothing was committed, tagged or pushed):
  git add SKILL.md CHANGELOG.md
  git commit -m "Release $NEW"
  git tag -a v$NEW -m "v$NEW"
  git push origin main v$NEW
MSG
