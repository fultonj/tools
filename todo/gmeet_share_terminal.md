# Problem Description

When using Google Chrome and Google Meet on Fedora 41 with the Sway window manager (Wayland), presenting individual Chrome tabs works, but presenting external windows (like the `foot` terminal) or the entire screen fails. The goal is to configure the system to allow sharing the `foot` terminal during a Google Meet call.

# Proposed Solution

AI Generated: Gemini 3.8 Thinking

Chrome needs a working pipeline through **PipeWire** and **xdg-desktop-portal-wlr** to capture windows and screens under Wayland. The following steps configure the necessary components.

## Step 1: Install Required Packages

Sway relies on the `wlroots` portal backend for screen and window capture, and `slurp` as the interactive chooser.

```bash
sudo dnf install -y \
  pipewire \
  xdg-desktop-portal \
  xdg-desktop-portal-wlr \
  xdg-desktop-portal-gtk \
  slurp
```

## Step 2: Configure Desktop Portals

Map the screen capture and screenshot portals to `wlr`.

Create `~/.config/xdg-desktop-portal/portals.conf`:

```ini
[preferred]
default=gtk
org.freedesktop.impl.portal.ScreenCast=wlr
org.freedesktop.impl.portal.Screenshot=wlr
```

## Step 3: Configure `xdg-desktop-portal-wlr`

Configure the chooser backend so you can select the screen or window to share.

Create `~/.config/xdg-desktop-portal-wlr/config`:

```ini
[screencast]
max_fps=30
chooser_type=simple
chooser_cmd=slurp -f 'Monitor: %o' -or
```

## Step 4: Import Environment Variables in Sway

Ensure the portal services know about your Wayland display environment. 

Add the following lines to your `~/.config/sway/config`:

```text
exec systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
exec dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
```

## Step 5: Enable WebRTC PipeWire Support in Chrome

1. Open Chrome and navigate to `chrome://flags/#enable-webrtc-pipewire-capturer`.
2. Set it to **Enabled**.
3. Ensure Chrome runs under native Wayland by checking `chrome://flags/#ozone-platform-hint` (set to **Auto** or **Wayland**).
4. Fully relaunch Chrome:
   ```bash
   pkill -f chrome
   ```

## Step 6: Restart Portal Services

Apply the new configurations by restarting the user services:

```bash
systemctl --user restart pipewire xdg-desktop-portal xdg-desktop-portal-wlr
```

Verify that they are active without errors:

```bash
systemctl --user status xdg-desktop-portal xdg-desktop-portal-wlr
```

## Expected Behavior

After applying these changes, clicking **Present now** -> **Your entire screen** (or **Window**) in Google Meet will prompt `slurp` (or the configured chooser) to let you select your target. The `foot` terminal can then be successfully shared on the call.
