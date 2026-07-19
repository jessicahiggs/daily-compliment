#!/usr/bin/env bash
# Schedule the daily compliment at a time you choose.
# Usage: macos/install-daily.sh HH:MM      (24-hour, e.g. 09:00 or 21:30)
#
# The skill asks the user what time they want their compliment, then runs this
# with that time. Re-run with a new time to change it. Uninstall with
# uninstall-daily.sh.
set -euo pipefail

time_arg="${1:-}"
if [[ ! "$time_arg" =~ ^([01]?[0-9]|2[0-3]):[0-5][0-9]$ ]]; then
  echo "Usage: $0 HH:MM   (24-hour, e.g. 09:00 for 9am, 21:30 for 9:30pm)" >&2
  exit 1
fi
hour=$((10#${time_arg%%:*}))
minute=$((10#${time_arg##*:}))

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
runner="$here/show-compliment.sh"
chmod +x "$runner"

label="com.user.daily-compliment"
plist="$HOME/Library/LaunchAgents/$label.plist"
mkdir -p "$HOME/Library/LaunchAgents"

cat > "$plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key><string>$label</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>$runner</string>
    </array>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Hour</key><integer>$hour</integer>
        <key>Minute</key><integer>$minute</integer>
    </dict>
    <key>StandardOutPath</key><string>/tmp/daily-compliment.log</string>
    <key>StandardErrorPath</key><string>/tmp/daily-compliment.err</string>
</dict>
</plist>
PLIST

# Reload cleanly if it was already scheduled.
launchctl unload "$plist" 2>/dev/null || true
launchctl load "$plist"

printf 'Done — your daily compliment is scheduled for %02d:%02d each day.\n' "$hour" "$minute"
echo "(Your Mac needs to be awake at that time; if it's asleep, it runs at next wake.)"
echo "Change the time: re-run this with a new time.  Stop it: ./uninstall-daily.sh"
