#!/usr/bin/env bash
# Keep the shared reader rules identical in every skill that embeds them.
#
# Source of truth: templates/reader-rules.md. A skill embeds a copy between
#   <!-- iclaw:reader-rules sha=<12 hex> -->
#   <!-- /iclaw:reader-rules -->
# The copy is inlined, not linked, because a skill is read alone and cannot rely on
# loading a second file. The sha makes a stale or hand-edited copy detectable.
#
# Line endings are ignored throughout: git may check files out with CRLF on Windows,
# and the installed plugin copy is such a checkout.
#
# Usage: reader_rules.sh check   -> exit 1 if any embedded copy differs from the source
#        reader_rules.sh sync    -> rewrite every embedded copy from the source
# Run `sync` after editing templates/reader-rules.md, then `check` before a release.
set -u
cd "$(dirname "$0")/.." || exit 1
SRC=templates/reader-rules.md
lf() { tr -d '\r' < "$1"; }
sha=$(lf "$SRC" | sha256sum | cut -c1-12)
mode="${1:-check}"
fails=0; found=0

for f in skills/*/SKILL.md; do
  grep -q '^<!-- iclaw:reader-rules ' "$f" || continue
  found=$((found+1))
  if [ "$mode" = "sync" ]; then
    tmp=$(mktemp); src=$(mktemp)
    lf "$SRC" > "$src"
    lf "$f" | awk -v src="$src" -v sha="$sha" '
      /^<!-- iclaw:reader-rules / {
        print "<!-- iclaw:reader-rules sha=" sha " -->"
        while ((getline line < src) > 0) print line
        close(src); skip=1; next }
      /^<!-- \/iclaw:reader-rules -->/ { skip=0 }
      !skip { print }' > "$tmp" && mv "$tmp" "$f"
    rm -f "$src"
    echo "synced: $f"
  else
    have=$(lf "$f" | sed -n 's/^<!-- iclaw:reader-rules sha=\([0-9a-f]*\) -->$/\1/p')
    body=$(lf "$f" | awk '/^<!-- iclaw:reader-rules /{b=1;next} /^<!-- \/iclaw:reader-rules -->/{b=0} b')
    if [ "$have" != "$sha" ]; then
      echo "FAIL: $f: reader-rules sha=$have, source is $sha (run: scripts/reader_rules.sh sync)"; fails=$((fails+1))
    elif [ "$body" != "$(lf "$SRC")" ]; then
      echo "FAIL: $f: reader-rules block edited by hand (run: scripts/reader_rules.sh sync)"; fails=$((fails+1))
    fi
  fi
done

[ "$mode" = "sync" ] && exit 0
[ "$fails" -eq 0 ] && echo "OK: $found skill(s) carry the current reader rules ($sha)" && exit 0
exit 1
