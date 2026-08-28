#!/usr/bin/env bash
# Validate a directory against the iclaw v3 protocol.
# Usage: validate_project.sh <project_dir>   -> exit 0 conforming, 1 otherwise
set -u
D="${1:?usage: validate_project.sh <project_dir>}"
fails=0
fail() { echo "FAIL: $*"; fails=$((fails+1)); }

# --- required structure -----------------------------------------------------
[ -f "$D/CLAUDE.md" ]            || fail "missing CLAUDE.md"
[ -d "$D/_memory" ]              || fail "missing _memory/"
[ -f "$D/_memory/LONGTERM.md" ]  || fail "missing _memory/LONGTERM.md"
[ -f "$D/_memory/STATE.md" ]     || fail "missing _memory/STATE.md"
[ -d "$D/_memory/sessions" ]     || fail "missing _memory/sessions/"
[ -d "$D/input" ]                || fail "missing input/"
[ -d "$D/output" ]               || fail "missing output/"
[ -d "$D/.memory" ]              && fail ".memory/ present - must be _memory/ (Obsidian ignores dot-dirs)"

# --- frontmatter helper -----------------------------------------------------
fm() { sed -n '/^---$/,/^---$/p' "$1" 2>/dev/null | sed -n "s/^$2: *//p" | head -1; }

# --- identity guard ---------------------------------------------------------
if [ -f "$D/CLAUDE.md" ] && [ -f "$D/_memory/LONGTERM.md" ]; then
  pc=$(fm "$D/CLAUDE.md" project)
  pl=$(fm "$D/_memory/LONGTERM.md" project)
  [ -n "$pc" ] || fail "CLAUDE.md has no project: field"
  [ "$pc" = "$pl" ] || fail "identity guard: CLAUDE.md project='$pc' != LONGTERM.md project='$pl'"
fi

# --- protocol version -------------------------------------------------------
for f in "$D/CLAUDE.md" "$D/_memory/LONGTERM.md" "$D/_memory/STATE.md"; do
  [ -f "$f" ] || continue
  v=$(fm "$f" protocol)
  [ "$v" = "iclaw/1.0.0" ] || fail "$(basename "$f"): protocol='$v', expected iclaw/1.0.0"
done

# --- session files ----------------------------------------------------------
for s in "$D"/_memory/sessions/*.md; do
  [ -e "$s" ] || continue
  b=$(basename "$s" .md); n=$(fm "$s" n); st=$(fm "$s" status)
  case "$b" in
    *_session)    exp=1 ;;
    *_session_*)  exp="${b##*_}" ;;
    *)            fail "$b: filename must end _session or _session_<n>"; continue ;;
  esac
  [ "$n" = "$exp" ] || fail "$b: frontmatter n='$n' disagrees with filename (expected $exp)"
  last=$(tr -d '[:space:]' < "$s" | tail -c 3)
  if [ "$st" = "sealed" ]; then
    [ "$last" = "끝" ] || fail "$b: status sealed but does not end with the seal marker"
  else
    [ "$last" = "끝" ] && fail "$b: ends with seal marker but status='$st' (must be sealed)"
  fi
done

# --- unfilled template placeholders -----------------------------------------
# A scaffolded file that still contains {like_this} was never seeded. This is the
# defect project-init's own rules forbid, and it is invisible until an agent reads
# the file and tries to act on the instruction inside the braces.
for f in "$D/CLAUDE.md" "$D/_memory/LONGTERM.md" "$D/_memory/STATE.md" \
         "$D"/_memory/sessions/*.md "$D"/_canon/*.md; do
  [ -f "$f" ] || continue
  case "$f" in "$D"/_memory/legacy/*) continue ;; esac
  hits=$(grep -o '{[^}]\{1,90\}}' "$f" 2>/dev/null | head -3)
  if [ -n "$hits" ]; then
    n=$(grep -c '{[^}]\{1,90\}}' "$f")
    fail "${f#$D/}: $n unfilled placeholder(s), first: $(echo "$hits" | head -1)"
  fi
done

# --- generated views stamped ------------------------------------------------
for v in "$D/_memory/_index.md" "$D/output/_manifest.md"; do
  [ -f "$v" ] || continue
  grep -q '^generated: .* method: ' "$v" || fail "$(basename "$v"): missing 'generated: ... method: ...' stamp"
done

# --- output artifact naming -------------------------------------------------
for f in "$D"/output/*/*; do
  [ -f "$f" ] || continue
  bn=$(basename "$f")
  echo "$bn" | grep -Eq '^[0-9]{2}_[a-z0-9-]+_v[0-9]+(_draft|_final)?\.[A-Za-z0-9]+$' \
    || fail "output/$(basename "$(dirname "$f")")/$bn: does not match {nn}_{slug}_v{n}[_status].{ext}"
done

# --- session-start read budget ----------------------------------------------
if [ -f "$D/_memory/STATE.md" ] && [ -f "$D/_memory/LONGTERM.md" ]; then
  lines=$(cat "$D/_memory/STATE.md" "$D/_memory/LONGTERM.md" | wc -l)
  [ "$lines" -le 100 ] || echo "WARN: session-start read is $lines lines (target <=100)"
fi

if [ "$fails" -eq 0 ]; then echo "OK: $D conforms to iclaw/1.0.0"; exit 0; fi
echo "$fails failure(s)"; exit 1
