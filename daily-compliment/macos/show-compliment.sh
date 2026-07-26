#!/usr/bin/env bash
# Generate today's compliment with Claude and show it in a dialog pop-up.
# This is what the daily launchd job (installed by install-daily.sh) runs.
#
# The pop-up is shown by Compliment.app — a small standalone AppleScript app that
# install-daily.sh builds and code-signs. Using a signed app (rather than a raw
# `osascript` call from bash) gives the dialog a STABLE identity, so macOS
# remembers its permission grant instead of re-prompting on every scheduled run.
set -uo pipefail

# Resolve this script's own folder (the macos/ dir) so Compliment.app can be
# found next to it, regardless of where the skill was cloned/installed.
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# launchd runs with a minimal PATH, so make the claude CLI findable.
export PATH="/opt/homebrew/bin:/usr/local/bin:$HOME/.local/bin:$HOME/bin:/usr/bin:/bin:$PATH"

PROMPT="Use your daily-compliment skill to write today's compliment for me, drawing on my recent conversations and memory. Output ONLY the single compliment sentence — no preamble, no quotes, no extra text."

compliment=""
if command -v claude >/dev/null 2>&1; then
  compliment="$(claude -p "$PROMPT" --dangerously-skip-permissions 2>/dev/null | tail -n 1 | tr -d '\r')"
fi

# Fallback if the CLI is unavailable or returns nothing.
if [ -z "${compliment// /}" ]; then
  compliment="You showed up today, and that counts."
fi

# Hand the text to Compliment.app via a small file it reads. The data dir is
# fixed and home-relative so the app always knows where to look.
data_dir="$HOME/.daily-compliment"
mkdir -p "$data_dir"
printf '%s' "$compliment" > "$data_dir/today.txt"

# Show it via the signed app if it's been built; otherwise fall back to a plain
# osascript dialog (works, but will prompt for permission on scheduled runs).
if [ -d "$here/Compliment.app" ]; then
  open -a "$here/Compliment.app" 2>/dev/null || true
else
  esc=${compliment//\\/\\\\}; esc=${esc//\"/\\\"}
  osascript -e "display dialog \"$esc\" with title \"Daily compliment ☀️\" buttons {\"Thanks\"} default button 1 giving up after 3600" >/dev/null 2>&1 || true
fi
