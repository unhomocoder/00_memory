#!/usr/bin/env bash
# Write or check the mode block in a CLAUDE.md.
#
# Source of truth: templates/modes/<preset>.md. Each project's CLAUDE.md carries an
# inlined copy between
#   <!-- iclaw:mode preset=<name> sha=<12 hex> -->
#   <!-- /iclaw:mode -->
# Inlined, not imported: Cowork is rooted at the project folder and loads no ancestor
# CLAUDE.md and no external @import, so every project must carry its own copy. The sha
# makes a stale or hand-edited copy detectable. HTML comments are stripped before the
# file reaches the model, so the delimiters cost nothing at runtime.
#
# Usage: mode_block.sh sync  <CLAUDE.md> [preset]   write or refresh the block
#                                                  (default preset: the one already
#                                                  named in the block, else "standard")
#        mode_block.sh check <CLAUDE.md>           exit 1 if missing, stale or edited
# A new block goes immediately before "## Conduct", else before "## Rules", else at
# the end. Line endings are ignored.
set -u
ROOT=$(cd "$(dirname "$0")/.." && pwd)
mode="${1:?usage: mode_block.sh sync|check <CLAUDE.md> [preset]}"
F="${2:?usage: mode_block.sh sync|check <CLAUDE.md> [preset]}"
[ -f "$F" ] || { echo "FAIL: $F not found"; exit 1; }
lf() { tr -d '\r' < "$1"; }

current=$(lf "$F" | sed -n 's/^<!-- iclaw:mode preset=\([a-z0-9_-]*\) sha=[0-9a-f]* -->$/\1/p' | head -1)
preset="${3:-${current:-standard}}"
SRC="$ROOT/templates/modes/$preset.md"
[ -f "$SRC" ] || { echo "FAIL: $F: mode preset '$preset' has no source at templates/modes/$preset.md"; exit 1; }
sha=$(lf "$SRC" | sha256sum | cut -c1-12)

if [ "$mode" = "check" ]; then
  n=$(lf "$F" | grep -c '^<!-- iclaw:mode ')
  [ "$n" -eq 1 ] || { echo "FAIL: $F: expected one mode block, found $n (run: scripts/mode_block.sh sync $F)"; exit 1; }
  have=$(lf "$F" | sed -n 's/^<!-- iclaw:mode preset=[a-z0-9_-]* sha=\([0-9a-f]*\) -->$/\1/p')
  body=$(lf "$F" | awk '/^<!-- iclaw:mode /{b=1;next} /^<!-- \/iclaw:mode -->/{b=0} b')
  if [ "$have" != "$sha" ]; then
    echo "FAIL: $F: mode block sha=$have, preset '$preset' is $sha (run: scripts/mode_block.sh sync $F)"; exit 1
  fi
  if [ "$body" != "$(lf "$SRC")" ]; then
    echo "FAIL: $F: mode block edited by hand (run: scripts/mode_block.sh sync $F)"; exit 1
  fi
  echo "OK: $F carries mode preset '$preset' ($sha)"; exit 0
fi

[ "$mode" = "sync" ] || { echo "usage: mode_block.sh sync|check <CLAUDE.md> [preset]"; exit 1; }
tmp=$(mktemp); src=$(mktemp)
lf "$SRC" > "$src"
lf "$F" | awk -v src="$src" -v head="<!-- iclaw:mode preset=$preset sha=$sha -->" '
  function emit() {
    print head
    while ((getline line < src) > 0) print line
    close(src)
    print "<!-- /iclaw:mode -->"
    print ""
    done = 1
  }
  { lines[NR] = $0 }
  /^<!-- iclaw:mode / { has = 1 }
  /^## Conduct$/ && !conduct { conduct = NR }
  /^## Rules$/ && !rules { rules = NR }
  END {
    at = has ? 0 : (conduct ? conduct : (rules ? rules : NR + 1))
    for (i = 1; i <= NR; i++) {
      if (has && lines[i] ~ /^<!-- iclaw:mode /) {
        emit(); skip = 1; continue
      }
      if (skip == 1) {
        if (lines[i] ~ /^<!-- \/iclaw:mode -->/) skip = 2
        continue
      }
      if (skip == 2) { skip = 0; if (lines[i] == "") continue }
      if (i == at) emit()
      print lines[i]
    }
    if (at == NR + 1) { print ""; emit() }
  }' > "$tmp" && mv "$tmp" "$F"
rm -f "$src"
echo "synced: $F (preset '$preset', $sha)"
