#!/bin/bash
set -euo pipefail
DEST="$HOME/Library/Application Support/LogiOptionsPlusRestarter"
APP="$HOME/Applications/Logi Options+ Restarter.app"
if [ -f "$HOME/.wakeup" ] && grep -Fq 'LogiOptionsPlusRestarter/wakeup.sh' "$HOME/.wakeup"; then
  rm "$HOME/.wakeup"
  echo 'Removed managed ~/.wakeup. Any pre-existing backup is preserved.'
fi
rm -rf "$DEST" "$APP"
echo 'Removed Logi Options+ Restarter. SleepWatcher remains installed for other uses.'
