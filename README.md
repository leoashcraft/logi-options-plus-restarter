# Logi Options+ Restarter for Mac

**Fix Logi Options+ (Logi Options Plus) on macOS when your Logitech mouse buttons, gestures, or scrolling stop working after your Mac wakes from sleep, or when Options+ silently crashes or stops responding.**

If your Logitech mouse still moves but its custom buttons, gesture button, thumb wheel, or smooth scrolling suddenly stopped working, the problem is often the Options+ background agent (`logioptionsplus_agent`). It can get stuck after sleep, or at random, without any error message. Options+ has no built-in way to recover from this. This free, open-source utility restarts the agent automatically every time your Mac wakes, and gives you a one-click Dock app for the times it fails in the middle of the day.

- **Automatic fix after sleep:** restarts the Options+ agent a few seconds after every wake
- **One-click Dock app:** fixes a silent crash in about two seconds, with no reboot, re-pairing, or reinstall
- **Lightweight:** plain shell scripts and a small AppleScript app you can read in a minute; no admin password needed
- **Works on Apple silicon and Intel Macs**
- **Leaves Logitech G HUB alone**

If this fixed your mouse or keyboard, please star the repo. Stars help other people with the same problem find it.

## Quick fix right now (no install)

Open Terminal and paste this to restart the Logi Options+ agent once:

```bash
pkill -x logioptionsplus_agent; sleep 2; pgrep -x logioptionsplus_agent >/dev/null || open "/Library/Application Support/Logitech.localized/LogiOptionsPlus/logioptionsplus_agent.app"
```

If your buttons and gestures come back, this tool is for you. [Install it](#install) so it happens automatically after every wake, with a Dock button for everything else.

## Symptoms this fixes

These usually mean the Logi Options+ agent has stopped working, either after your Mac wakes from sleep or at random:

- The mouse cursor moves and left/right click work, but **custom button assignments do nothing**
- The **gesture button** or **thumb button** on an MX Master stops working
- The **horizontal thumb wheel** stops scrolling or reverts to default behavior
- **Smooth scrolling** or **app-specific settings** stop applying
- Custom keys on an MX Keys or other Logitech keyboard **revert to their defaults**
- **Logitech Flow** stops switching between computers
- The Options+ window is **stuck on a loading spinner** or says it **can't find your device**
- Options+ seems to **crash silently**: no error, the settings just stop working until you reboot

## Why this happens

Logi Options+ has two parts: the Options+ window where you change settings, and a background agent, `logioptionsplus_agent`, that runs all the time and applies those settings to your devices. Basic pointer movement and clicks are handled by macOS itself, which is why the mouse keeps working when the agent fails and only your customizations disappear.

When a Mac sleeps, Bluetooth and Logi Bolt/Unifying receiver connections drop and reconnect. Sometimes the agent doesn't recover from that, and sometimes it hangs on its own. macOS relaunches the agent if it exits outright, so a "silent crash" usually means the agent is still running but stuck. Quitting and reopening the Options+ window doesn't help, because the window isn't the agent.

The usual advice is to re-grant Accessibility and Input Monitoring permissions, re-pair the device, reinstall Options+, or reboot. Those either don't help at all or only last until the next sleep. I built this tool after none of them fixed it for me.

Restarting the agent is the fastest reliable fix. This tool automates it.

## Install

### Requirements

- macOS with [Logi Options+](https://www.logitech.com/software/logi-options-plus.html) installed in its standard location
- [Homebrew](https://brew.sh), for the automatic restart after wake (optional; the Dock app works without it)

### Steps

1. **Download** this repository: click **Code → Download ZIP** and unzip it, or clone it:

   ```bash
   git clone https://github.com/leoashcraft/logi-options-plus-restarter.git
   ```

2. **Open Terminal** and go into the folder. If you cloned it:

   ```bash
   cd logi-options-plus-restarter
   ```

   If you downloaded the ZIP into Downloads:

   ```bash
   cd ~/Downloads/logi-options-plus-restarter-main
   ```

3. **Run the installer:**

   ```bash
   chmod +x scripts/*.sh macos/wakeup.sh && ./scripts/install.sh
   ```

4. **Add the app to your Dock:** in Finder, choose **Go → Home**, open **Applications**, and drag **Logi Options+ Restarter** to the Dock.

The installer:

- copies the scripts to `~/Library/Application Support/LogiOptionsPlusRestarter`
- builds the Dock app at `~/Applications/Logi Options+ Restarter.app` (built on your Mac, so there's no "unidentified developer" warning)
- installs [SleepWatcher](https://www.bernhard-baehr.de/) with Homebrew if it isn't already installed
- sets up `~/.wakeup` so the agent restarts five seconds after every wake

Without Homebrew, the installer still builds the Dock app. Install Homebrew and run the installer again to add the automatic wake restart.

> **Warning:** If you already have a `~/.wakeup` script, the installer backs it up to `~/.wakeup.backup.logi-restarter.<timestamp>` and replaces it. Merge any wake tasks you need from the backup.

## Usage

- **After sleep:** nothing to do. The agent restarts automatically when your Mac wakes.
- **When Options+ stops working at any other time:** click **Logi Options+ Restarter** in the Dock. You'll get a notification when the restart has been requested.

You can also run the restart from Terminal:

```bash
"$HOME/Library/Application Support/LogiOptionsPlusRestarter/restart.sh"
```

## Check that it's working

SleepWatcher should be listed as `started`:

```bash
brew services list
```

Each restart is logged with a timestamp:

```bash
tail -20 "$HOME/Library/Logs/LogiOptionsPlusRestarter.log"
```

## Troubleshooting: when restarting the agent won't help

- **Options+ crashes on launch or won't open at all (since January 2026):** Logitech's code-signing certificate expired on January 6, 2026, which broke older Options+ installs. Download the latest Logi Options+ from Logitech. Restarting the agent can't fix an expired certificate.
- **The mouse doesn't move at all after sleep:** that's a Bluetooth connection problem, not the Options+ agent. See Logitech's article [Mouse loses connection after computer has gone to sleep](https://support.logi.com/hc/en-gb/articles/5304312762903-Mouse-loses-connection-after-computer-has-gone-to-sleep).
- **Your settings never work, even right after a restart:** open **System Settings → Privacy & Security** and confirm Logi Options+ is allowed under **Accessibility**, **Input Monitoring**, and **Bluetooth**. Re-granting these doesn't fix the after-sleep problem, but if a macOS update removed them, the agent can't apply your settings at all.
- **The log says "Agent application not found":** Options+ isn't installed in its standard location. Reinstall Options+ from Logitech.

## FAQ

### Why do my Logitech mouse buttons stop working after my Mac wakes from sleep?

The Logi Options+ background agent, which applies your button, gesture, and scroll settings, often fails to recover when Bluetooth or the Logi Bolt receiver reconnects after sleep. The mouse falls back to basic macOS behavior until the agent restarts. This tool restarts it for you after every wake.

### Is there a setting in Logi Options+ to fix this?

No. Options+ has no setting to restart its agent after sleep or after it stops responding. The usual suggestions (re-grant permissions, reinstall, re-pair, reboot, reset settings) may help for a while, but they don't stop the problem from coming back.

### I already re-enabled Accessibility and Input Monitoring for Logi Options+. Why do my buttons still not work?

Those permissions decide whether the agent is allowed to apply your settings. They can't help when the agent itself is stuck, which is what usually happens after sleep. If the permissions are already turned on and your buttons stopped working after sleep, restarting the agent is what brings them back.

### Does this fix Logi Options+ randomly crashing or freezing?

It handles the wake-from-sleep case automatically. When the agent fails at another time, click the Dock app and your settings are back in about two seconds, with no reboot.

### Will it work with my MX Master 3S, MX Keys, or other Logitech device?

The tool doesn't talk to your device. It restarts the Options+ agent, so it applies to any mouse or keyboard that Logi Options+ manages, including the MX Master, MX Anywhere, MX Ergo, MX Keys, Lift, and Signature series, over Bluetooth or a Logi Bolt/Unifying receiver.

### Does it work with the old Logitech Options app or with G HUB?

No. It targets only the Logi Options+ agent (`logioptionsplus_agent`). The older Logitech Options app uses different processes, and Logitech G HUB is left alone.

### Will I lose my Options+ settings?

No. Your settings are saved by Options+ and reloaded when the agent starts. The tool stops and relaunches the agent process; it doesn't change any Logitech files.

### Do I need Homebrew?

Only for the automatic restart after wake, which uses SleepWatcher. Without Homebrew you still get the Dock app.

## Uninstall

```bash
./scripts/uninstall.sh
```

This removes the scripts, the Dock app, and the managed `~/.wakeup` hook. It leaves Homebrew and SleepWatcher installed and keeps any `~/.wakeup` backup. Remove the Dock icon by dragging it out of the Dock.

## How it works

Options+ registers its agent with launchd (`/Library/LaunchAgents/com.logi.optionsplus.plist`), which normally relaunches the agent if it exits unexpectedly. The restart script:

1. sends SIGTERM to `logioptionsplus_agent`
2. waits two seconds
3. opens `/Library/Application Support/Logitech.localized/LogiOptionsPlus/logioptionsplus_agent.app` if launchd hasn't already relaunched the agent
4. writes each step to `~/Library/Logs/LogiOptionsPlusRestarter.log`

On wake, SleepWatcher runs `~/.wakeup`, which waits five seconds for Bluetooth and USB receivers to reconnect and then runs the same restart script. The Dock app is a compiled AppleScript that runs the restart script and shows a notification.

## License

[MIT](LICENSE)

This is an independent community utility. It is not affiliated with or endorsed by Logitech. Logitech, Logi, Logi Options+, MX Master, and MX Keys are trademarks of Logitech.
