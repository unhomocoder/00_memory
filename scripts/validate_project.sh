#!/usr/bin/env bash
# Validate a directory against the iclaw v3 protocol.
# Usage: validate_project.sh <project_dir>   -> exit 0 conforming, 1 otherwise
#
# FAIL  a defect you can and should fix. Sets exit 1.
# NOTE  a finding on a file the protocol forbids you to edit (sealed, or under
#       _memory/legacy/), or an advisory. Reported, never fixed, exit unaffected.
# WARN  a target exceeded, not a rule broken.
set -u
D="${1:?usage: validate_project.sh <project_dir>}"
fails=0
fail() { echo "FAIL: $*"; fails=$((fails+1)); }
note() { echo "NOTE: $*"; }

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
#
# Scan template-derived text only. A session log's ## Work body is free prose the
# agent writes, where braces are shell expansion, set notation, or the protocol
# quoted back -- all indistinguishable from a placeholder by pattern, so the
# region is excluded rather than the pattern narrowed.
scan() {
  case "$1" in
    "$D"/_memory/sessions/*) sed '/^## Work/,$d' "$1" ;;
    *)                       cat "$1" ;;
  esac
}
for f in "$D/CLAUDE.md" "$D/_memory/LONGTERM.md" "$D/_memory/STATE.md" \
         "$D"/_memory/sessions/*.md "$D"/_canon/*.md; do
  [ -f "$f" ] || continue
  case "$f" in "$D"/_memory/legacy/*) continue ;; esac
  hits=$(scan "$f" | grep -o '{[^}]\{1,90\}}' | head -3)
  [ -n "$hits" ] || continue
  n=$(scan "$f" | grep -c '{[^}]\{1,90\}}')
  msg="${f#$D/}: $n unfilled placeholder(s), first: $(echo "$hits" | head -1)"
  # A sealed file is immutable. Report, never demand a fix.
  if [ "$(fm "$f" status)" = "sealed" ]; then note "$msg"; else fail "$msg"; fi
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

# --- contract: CLAUDE.md is self-sufficient ---------------------------------
# A file that defers a rule to a parent works in Claude Code, which loads ancestor
# CLAUDE.md files, and fails silently in Cowork, which is rooted at this folder and
# has no ancestor to load.
if [ -f "$D/CLAUDE.md" ] && grep -q '\.\./CLAUDE\.md' "$D/CLAUDE.md"; then
  fail "CLAUDE.md defers to a parent CLAUDE.md - it must state its own rules in full"
fi

# --- contract: canon declaration agrees with the filesystem -----------------
if [ -f "$D/CLAUDE.md" ]; then
  cdecl=$(fm "$D/CLAUDE.md" canon)
  if [ "$cdecl" = "./_canon" ] && [ ! -d "$D/_canon" ]; then
    fail "CLAUDE.md declares canon: ./_canon but no _canon/ directory exists"
  fi
  if [ "$cdecl" = "none" ] && [ -d "$D/_canon" ]; then
    fail "_canon/ exists but CLAUDE.md declares canon: none"
  fi
fi

# --- contract: relative canon paths resolve against their own file ----------
# Only traversal paths (../.../_canon/x.md) are checked. A bare "_canon/x.md" in
# prose names a file, it does not assert a path.
for f in "$D/CLAUDE.md" "$D/_memory/LONGTERM.md" "$D/_memory/STATE.md" "$D"/_canon/*.md; do
  [ -f "$f" ] || continue
  base=$(dirname "$f")
  for p in $(grep -oE '(\.\./)+_canon/[A-Za-z0-9_.-]+\.md' "$f" | sort -u); do
    [ -e "$base/$p" ] || fail "${f#$D/}: canon path '$p' does not resolve (paths are relative to the file, not the project root)"
  done
done

# --- contract: live branch rows name a directory that exists ----------------
if [ -f "$D/_memory/LONGTERM.md" ]; then
  grep -q '^## Branches$' "$D/_memory/LONGTERM.md" \
    && note "LONGTERM.md uses the old '## Branches' heading; the scoped form is '## Branches of this project'"
  # A correct row splits into 6 fields on "|" (empty, branch, created, status,
  # purpose, empty). Five means the Status column is missing, and field 4 would
  # otherwise be read as the status when it is really the purpose.
  brout=$(awk -F'|' -v D="$D" '
    /^## Branches of this project/ { b=1; next }
    /^## / { b=0 }
    b && /^\| *[0-9][0-9]_/ {
      br=$2; gsub(/^ +| +$/, "", br)
      if (NF < 6) { printf "FAIL: LONGTERM.md branch row \047%s\047 has no Status column\n", br; next }
      st=$4; gsub(/^ +| +$/, "", st)
      # active  = live this term          dormant = inactive, will return (a course
      # between terms)                    retired = over, not coming back
      if (st !~ /^(active|dormant|retired)/) {
        printf "FAIL: LONGTERM.md branch row \047%s\047 has status \047%s\047; expected active, dormant <date> or retired <date>\n", br, st
        next
      }
      if (st == "active" && system("test -d \"" D "/" br "\"") != 0)
        printf "FAIL: LONGTERM.md branch row \047%s\047 is marked active but the directory does not exist\n", br
    }' "$D/_memory/LONGTERM.md")
  if [ -n "$brout" ]; then
    echo "$brout"
    fails=$((fails + $(echo "$brout" | wc -l)))
  fi
fi

# --- session-start read budget ----------------------------------------------
if [ -f "$D/_memory/STATE.md" ] && [ -f "$D/_memory/LONGTERM.md" ]; then
  lines=$(cat "$D/_memory/STATE.md" "$D/_memory/LONGTERM.md" | wc -l)
  [ "$lines" -le 200 ] || echo "WARN: session-start read is $lines lines (target <=200)"
fi

if [ "$fails" -eq 0 ]; then echo "OK: $D conforms to iclaw/1.0.0"; exit 0; fi
echo "$fails failure(s)"; exit 1
