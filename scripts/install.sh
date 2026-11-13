#!/bin/bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DEST="$HOME/Library/Application Support/LogiOptionsPlusRestarter"
APP_DIR="$HOME/Applications"
mkdir -p "$DEST" "$APP_DIR"
install -m 755 "$ROOT/scripts/restart.sh" "$DEST/restart.sh"
install -m 755 "$ROOT/macos/wakeup.sh" "$DEST/wakeup.sh"
if ! command -v osacompile >/dev/null; then
  echo 'This installer must run on macOS.' >&2; exit 1
fi
osacompile -o "$APP_DIR/Logi Options+ Restarter.app" "$ROOT/macos/Logi Options+ Restarter.applescript"
if command -v brew >/dev/null; then
  if ! brew list --versions sleepwatcher >/dev/null 2>&1 || [ -z "$(brew list --versions sleepwatcher)" ]; then
    echo 'Installing SleepWatcher via Homebrew...'
    brew install sleepwatcher
  fi
  if [ -e "$HOME/.wakeup" ] && ! grep -q 'LogiOptionsPlusRestarter/wakeup.sh' "$HOME/.wakeup"; then
    cp "$HOME/.wakeup" "$HOME/.wakeup.backup.logi-restarter.$(date +%Y%m%d%H%M%S)"
    echo 'Existing ~/.wakeup detected; backup created.'
  fi
  cat > "$HOME/.wakeup" <<'WAKE'
#!/bin/bash
"$HOME/Library/Application Support/LogiOptionsPlusRestarter/wakeup.sh"
WAKE
  chmod +x "$HOME/.wakeup"
  brew services restart sleepwatcher
else
  echo 'Homebrew not found. Dock app installed, but automatic wake restart requires SleepWatcher.'
  echo 'Install Homebrew, then rerun this installer.'
fi
printf '\nInstalled: %s\nDrag this app to your Dock.\n' "$APP_DIR/Logi Options+ Restarter.app"
