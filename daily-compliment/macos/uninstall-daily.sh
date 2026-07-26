#!/usr/bin/env bash
# Stop and remove the scheduled daily compliment.
set -euo pipefail
label="com.user.daily-compliment"
plist="$HOME/Library/LaunchAgents/$label.plist"
launchctl unload "$plist" 2>/dev/null || true
rm -f "$plist"

# Remove the built pop-up app and the day's text file (harmless if absent).
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
rm -rf "$here/Compliment.app"
rm -rf "$HOME/.daily-compliment"

echo "Removed — the daily compliment schedule is off. (You can still ask for one any time.)"
