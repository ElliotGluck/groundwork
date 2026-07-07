#!/usr/bin/env bash
#
# Groundwork installer — multi-harness
# -------------------------------------------------------------------------------------------------
# Installs Groundwork for your coding agent(s): Claude Code, Codex CLI, OpenCode, Cursor, or any
# SKILL.md-compatible agent. Interactive by default; flags for automation.
#
# One-liner (from GitHub):
#   curl -fsSL https://raw.githubusercontent.com/ElliotGluck/groundwork/main/setup/install.sh | bash
#
# What it installs per harness:
#   - Skills (universal SKILL.md format) → the harness's skills directory
#   - The always-on operating contract → CLAUDE.md (Claude Code) or AGENTS.md (others)
#   - Claude Code additionally gets the full plugin (commands + coding-worker/verifier agents)
#
# SAFE TO RE-RUN: contract content lives between sentinel markers and is replaced in place;
# skills are synced by folder. Existing user content is never touched. Backups are made.
#
# Usage:
#   ./install.sh                     # interactive (pick your editor/agent)
#   ./install.sh --agent claude     # non-interactive: claude | codex | opencode | cursor | agnostic | all
#   ./install.sh --dry-run          # show what would happen
#   ./install.sh --uninstall        # remove managed blocks + print skill-removal paths
#   ./install.sh --help

set -euo pipefail

REPO_URL="https://github.com/ElliotGluck/groundwork"
BEGIN_MARKER="<!-- GROUNDWORK:BEGIN (managed block — do not edit; re-run installer to update) -->"
END_MARKER="<!-- GROUNDWORK:END -->"

# ---- locate source (repo checkout, or fetch when piped from curl) --------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || echo "")"
if [ -n "$SCRIPT_DIR" ] && [ -f "${SCRIPT_DIR}/../skills/grounded-coding/SKILL.md" ]; then
  SRC="$(cd "${SCRIPT_DIR}/.." && pwd)"
else
  # piped install: clone to a temp dir
  command -v git >/dev/null 2>&1 || { echo "git is required for the one-liner install."; exit 1; }
  SRC="$(mktemp -d)/groundwork"
  echo "Fetching Groundwork from ${REPO_URL} ..."
  git clone --depth 1 "$REPO_URL" "$SRC" >/dev/null 2>&1 || { echo "Clone failed. Check network/URL."; exit 1; }
fi

# ---- args -----------------------------------------------------------------------------------------
DRY_RUN=0; DO_UNINSTALL=0; AGENT=""
while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run) DRY_RUN=1 ;;
    --uninstall) DO_UNINSTALL=1 ;;
    --agent) shift; AGENT="$1" ;;
    -h|--help) sed -n '3,26p' "${BASH_SOURCE[0]:-$0}" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "Unknown option: $1 (try --help)" >&2; exit 2 ;;
  esac; shift
done

say()  { printf '  %s\n' "$*"; }
ok()   { printf '  \342\234\223 %s\n' "$*"; }
warn() { printf '  ! %s\n' "$*" >&2; }
hdr()  { printf '\n== %s ==\n' "$*"; }
run()  { if [ "$DRY_RUN" = 1 ]; then printf '  [dry-run] %s\n' "$*"; else eval "$@"; fi; }

backup_file() { local f="$1"; [ -f "$f" ] || return 0
  local b="${f}.groundwork.bak.$(date +%Y%m%d%H%M%S)"
  if [ "$DRY_RUN" = 1 ]; then say "[dry-run] would back up $f"; else cp "$f" "$b"; say "backup: $b"; fi; }

# Replace-in-place managed block (create file / replace block / append block)
install_block() { # install_block <target-file> <content-file>
  local target="$1" content="$2" tmp; tmp="$(mktemp)"
  { printf '%s\n' "$BEGIN_MARKER"; cat "$content"; printf '%s\n' "$END_MARKER"; } > "$tmp"
  run "mkdir -p \"$(dirname "$target")\""
  if [ ! -f "$target" ]; then
    if [ "$DRY_RUN" = 1 ]; then say "[dry-run] would create $target"; else cp "$tmp" "$target"; ok "created $target"; fi
  elif grep -qF "$BEGIN_MARKER" "$target" && grep -qF "$END_MARKER" "$target"; then
    backup_file "$target"
    if [ "$DRY_RUN" = 0 ]; then
      awk -v b="$BEGIN_MARKER" -v e="$END_MARKER" -v bf="$tmp" '
        $0==b { while ((getline line < bf) > 0) print line; close(bf); skip=1; next }
        $0==e && skip { skip=0; next } !skip { print }' "$target" > "${target}.tmp" && mv "${target}.tmp" "$target"
    fi
    ok "updated Groundwork block in place ($target — rest untouched)"
  elif grep -qF "$BEGIN_MARKER" "$target"; then
    warn "BEGIN without END marker in $target — not editing to avoid data loss. Fix markers and re-run."
  else
    backup_file "$target"
    if [ "$DRY_RUN" = 0 ]; then { printf '\n'; cat "$tmp"; } >> "$target"; fi
    ok "appended Groundwork block ($target — existing content preserved)"
  fi
  rm -f "$tmp"
}

remove_block() { local target="$1"
  if [ -f "$target" ] && grep -qF "$BEGIN_MARKER" "$target"; then
    backup_file "$target"
    if [ "$DRY_RUN" = 0 ]; then
      awk -v b="$BEGIN_MARKER" -v e="$END_MARKER" '$0==b{skip=1;next} $0==e&&skip{skip=0;next} !skip{print}' \
        "$target" > "${target}.tmp" && mv "${target}.tmp" "$target"
    fi
    ok "removed managed block from $target"
  fi; }

sync_skills() { # sync_skills <dest-skills-dir>
  local dest="$1"
  run "mkdir -p \"$dest\""
  for s in grounded-coding experimental-reasoning; do
    run "rm -rf \"${dest}/${s}\""
    run "cp -R \"${SRC}/skills/${s}\" \"${dest}/${s}\""
  done
  ok "skills synced → $dest (grounded-coding, experimental-reasoning)"
}

# ---- per-harness installs --------------------------------------------------------------------------
install_claude() {
  hdr "Claude Code"
  sync_skills "$HOME/.claude/skills"
  # full plugin (commands + agents) via local marketplace, matching prior installer behavior
  local stage="$HOME/.claude/marketplaces/groundwork-local"
  run "mkdir -p \"${stage}/groundwork/.claude-plugin\" \"${stage}/.claude-plugin\""
  for item in .claude-plugin skills commands agents README.md; do
    [ -e "${SRC}/${item}" ] && { run "rm -rf \"${stage}/groundwork/${item}\""; run "cp -R \"${SRC}/${item}\" \"${stage}/groundwork/${item}\""; }
  done
  if [ "$DRY_RUN" = 0 ]; then cat > "${stage}/.claude-plugin/marketplace.json" <<JSON
{ "name": "groundwork-local", "owner": { "name": "groundwork (local install)" },
  "plugins": [ { "name": "groundwork", "source": "./groundwork",
    "description": "Grounded orchestrator/PM coding profiles, gates, commands, and worker/verifier agents." } ] }
JSON
  fi
  ok "plugin staged (commands: /debug /architect /review /scope /flatten-plan /ground-check; agents: coding-worker, verifier)"
  if command -v claude >/dev/null 2>&1; then
    run "claude plugin marketplace add \"${stage}\" >/dev/null 2>&1" && \
    run "claude plugin install groundwork@groundwork-local --scope user >/dev/null 2>&1" && \
    ok "plugin installed via claude CLI" || warn "CLI install incomplete — inside Claude Code run: /plugin marketplace add ${stage} then /plugin install groundwork@groundwork-local"
  else
    say "claude CLI not found — inside Claude Code run:"
    say "  /plugin marketplace add ${stage}"
    say "  /plugin install groundwork@groundwork-local"
  fi
  install_block "$HOME/.claude/CLAUDE.md" "${SRC}/setup/global-CLAUDE.md"
}

install_codex()    { hdr "Codex CLI";  sync_skills "$HOME/.codex/skills";  install_block "$HOME/.codex/AGENTS.md" "${SRC}/setup/global-AGENTS.md"; say "restart Codex to pick up new skills"; }
install_opencode() { hdr "OpenCode";   sync_skills "$HOME/.config/opencode/skills" ; install_block "$HOME/.config/opencode/AGENTS.md" "${SRC}/setup/global-AGENTS.md"; say "if skills don't load, set skill.paths in your OpenCode config to include the directory above"; }
install_cursor()   { hdr "Cursor";     say "Cursor loads skills per-project (.cursor/skills/) and rules via AGENTS.md in the repo."
  local proj; proj="$(pwd)"
  printf '  Install into current project (%s)? [y/N] ' "$proj"
  local yn; if [ "${NONINTERACTIVE:-0}" = 1 ]; then yn=y; else read -r yn </dev/tty || yn=n; fi
  case "$yn" in [Yy]*) sync_skills "${proj}/.cursor/skills"; install_block "${proj}/AGENTS.md" "${SRC}/setup/global-AGENTS.md";;
    *) say "skipped — re-run inside the project you want it in";; esac; }
install_agnostic() { hdr "Agent-agnostic (.agents/skills — emerging consensus dir)"
  sync_skills "$HOME/.agents/skills"; install_block "$HOME/AGENTS.md" "${SRC}/setup/global-AGENTS.md"
  say "note: harnesses vary in whether they scan these paths; use a specific harness option when possible"; }

# ---- uninstall -------------------------------------------------------------------------------------
if [ "$DO_UNINSTALL" = 1 ]; then
  hdr "Groundwork uninstall"
  remove_block "$HOME/.claude/CLAUDE.md"; remove_block "$HOME/.codex/AGENTS.md"
  remove_block "$HOME/.config/opencode/AGENTS.md"; remove_block "$HOME/AGENTS.md"
  say "Skill folders to delete if desired:"
  for d in "$HOME/.claude/skills" "$HOME/.codex/skills" "$HOME/.config/opencode/skills" "$HOME/.agents/skills"; do
    for s in grounded-coding experimental-reasoning; do [ -d "$d/$s" ] && say "  rm -rf $d/$s"; done; done
  say "Claude Code plugin: /plugin uninstall groundwork@groundwork-local ; /plugin marketplace remove groundwork-local"
  exit 0
fi

# ---- interactive selection --------------------------------------------------------------------------
hdr "Groundwork installer"
say "source: $SRC"
[ "$DRY_RUN" = 1 ] && say "(dry run — no changes will be made)"

if [ -z "$AGENT" ]; then
  echo
  echo "  Which coding agent(s) do you use?"
  echo "    1) Claude Code   (full plugin: skills + commands + worker/verifier agents + CLAUDE.md)"
  echo "    2) Codex CLI     (skills + global AGENTS.md)"
  echo "    3) OpenCode      (skills + AGENTS.md)"
  echo "    4) Cursor        (project-level skills + AGENTS.md)"
  echo "    5) Agent-agnostic (.agents/skills + ~/AGENTS.md)"
  echo "    6) All of the above"
  printf "  Select [1-6]: "
  read -r choice </dev/tty || choice=1
  case "$choice" in
    1) AGENT=claude ;; 2) AGENT=codex ;; 3) AGENT=opencode ;; 4) AGENT=cursor ;; 5) AGENT=agnostic ;; 6) AGENT=all ;;
    *) warn "invalid selection"; exit 2 ;;
  esac
fi

case "$AGENT" in
  claude)   install_claude ;;
  codex)    install_codex ;;
  opencode) install_opencode ;;
  cursor)   install_cursor ;;
  agnostic) install_agnostic ;;
  all)      install_claude; install_codex; install_opencode; NONINTERACTIVE=1 install_cursor; install_agnostic ;;
  *) warn "unknown --agent '$AGENT' (claude|codex|opencode|cursor|agnostic|all)"; exit 2 ;;
esac

hdr "Done"
say "Verify: start a session and confirm the skills appear (Claude Code: /plugins & /memory; Codex: /skills)."
[ "$DRY_RUN" = 1 ] && say "(dry run — nothing was actually changed)"
