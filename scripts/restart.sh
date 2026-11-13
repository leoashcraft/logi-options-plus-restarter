#!/bin/bash
set -u
APP='/Library/Application Support/Logitech.localized/LogiOptionsPlus/logioptionsplus_agent.app'
LOG="$HOME/Library/Logs/LogiOptionsPlusRestarter.log"
mkdir -p "$(dirname "$LOG")"
if [ ! -d "$APP" ]; then
  echo "$(date): Agent application not found: $APP" >> "$LOG"
  exit 1
fi
echo "$(date): Restart requested" >> "$LOG"
pkill -TERM -x logioptionsplus_agent 2>/dev/null || true
sleep 2
if ! pgrep -x logioptionsplus_agent >/dev/null; then
  open "$APP" || exit 1
fi
echo "$(date): Restart completed" >> "$LOG"
