#!/usr/bin/env bash
# Rebuild _memory/_index.md from the session files it is a view over.
# Usage: reindex.sh <project_dir>
#
# The index is a VIEW. Session files are the source, and every column below is
# read out of one -- nothing is inferred and nothing is carried over from the
# previous index. Run this whenever the view is wanted; it is not tied to seal.
set -u
D="${1:?usage: reindex.sh <project_dir>}"
[ -d "$D/_memory/sessions" ] || { echo "no $D/_memory/sessions/ - not an iclaw project?" >&2; exit 1; }

fm() { sed -n '/^---$/,/^---$/p' "$1" 2>/dev/null | sed -n "s/^$2: *//p" | head -1; }

project=$(fm "$D/_memory/LONGTERM.md" project)
[ -n "$project" ] || project=$(basename "$D")
today=$(date +%Y-%m-%d)
out="$D/_memory/_index.md"

{
  echo "# Session Index — $project"
  echo
  echo "generated: $today · method: reindex.sh"
  echo
  echo "View over \`sessions/\`. Session files are the source. Never add information here"
  echo "that is not in a session file. Rebuild with \`scripts/reindex.sh\`; do not hand-edit."
  echo
  echo "| Session | Date | Scope | Focus | Artifacts | Sealed |"
  echo "|---|---|---|---|---|---|"

  for s in "$D"/_memory/sessions/*.md; do
    [ -e "$s" ] || continue
    b=$(basename "$s")
    date=$(fm "$s" date);   [ -n "$date" ]  || date="—"
    scope=$(fm "$s" scope); [ -n "$scope" ] || scope="—"
    st=$(fm "$s" status)

    # Artifacts: lines under ## Files Touched -> ### Produced naming an output/ path.
    arts=$(awk '/^### Produced/{p=1;next} /^### |^## /{p=0} p' "$s" \
           | grep -c '`output/' || true)
    [ "$arts" = "0" ] && arts="—"

    # Focus: first real line of ## Summary. Placeholder and italic stub lines
    # ("_Written at seal time._") are not content, so they read as no focus yet.
    focus=$(awk '/^## Summary/{p=1;next} /^## /{p=0} p' "$s" \
            | grep -v '^[[:space:]]*$' | grep -v '^_' | grep -v '^{' | head -1 \
            | cut -c1-60)
    [ -n "$focus" ] || focus="—"

    if [ "$st" = "sealed" ]; then sealed="yes"; else sealed="no"; fi
    echo "| $b | $date | $scope | $focus | $arts | $sealed |"
  done
} > "$out"

rows=$(grep -c '^| [0-9]' "$out" || true)
echo "reindexed $out — $rows session row(s)"
