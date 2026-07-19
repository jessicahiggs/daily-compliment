#!/usr/bin/env bash
# Generate today's compliment with Claude and show it in a dialog pop-up.
# This is what the daily launchd job (installed by install-daily.sh) runs.
# A dialog is used instead of a notification banner because it needs no
# notification permissions and reliably appears on any Mac.
set -uo pipefail

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

# Escape backslashes and double quotes for AppleScript.
esc=${compliment//\\/\\\\}
esc=${esc//\"/\\\"}

osascript -e "display dialog \"$esc\" with title \"Daily compliment ☀️\" buttons {\"Thanks\"} default button 1 giving up after 3600" >/dev/null 2>&1 || true
