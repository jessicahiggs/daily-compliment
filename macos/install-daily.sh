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

# Build Compliment.app — the pop-up is shown by a small standalone, code-signed
# app instead of a raw osascript call. A signed app has a stable identity, so
# macOS remembers the permission grant instead of re-prompting the daily job
# forever. (A bare bash -> osascript chain has no durable identity to grant.)
app="$here/Compliment.app"
src="$here/compliment-dialog.applescript"
if [[ -f "$src" ]]; then
  rm -rf "$app"
  osacompile -o "$app" "$src"
  info="$app/Contents/Info.plist"
  /usr/libexec/PlistBuddy -c "Add :CFBundleIdentifier string com.user.daily-compliment" "$info" 2>/dev/null \
    || /usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier com.user.daily-compliment" "$info"
  /usr/libexec/PlistBuddy -c "Add :CFBundleName string Compliment" "$info" 2>/dev/null || true
  # Ad-hoc signature: enough to give TCC a stable identity to attach the grant to.
  codesign --force --deep -s - "$app" >/dev/null 2>&1 || true
else
  echo "note: compliment-dialog.applescript not found — the pop-up will use a" >&2
  echo "      plain dialog that may prompt for permission on each scheduled run." >&2
fi

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
