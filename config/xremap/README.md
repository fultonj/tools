# xremap on sway

I use [xremap](https://github.com/xremap/xremap)
to implement the following key bindings in Chrome.
```
GNU      CUA
--------------------------------
ctrl+a   home
ctrl+e   end
alt+f    ctrl-right
alt+b    ctrl-left
ctrl+k   select-all in front of cursor and cut
ctrl+u   select-all and delete
ctrl+d   delete
ctrl+p   up
ctrl+n   down
ctrl+y   paste
```
The key bindings on the left are from GNU and I have them in my muscle
memory. The keybindings on the right are the GNU equivalent in CUA.
The term CUA bindings comes from IBM's Common User Access standard,
which was later adopted by Microsoft.

I used to just start Chrome with something like this:
```
Exec=env GTK_KEY_THEME=Emacs google-chrome-stable %U
```
Unfortunately Chromium 116+ no longer respects gtk-key-theme-name
setting: https://issues.chromium.org/issues/40279679 so I use xremap.

xremap is a key remapper for Wayland that supports application-specific remapping.
This guide sets it up to translate GNU Emacs-style keybindings to CUA equivalents in Chrome.

## Install

```bash
sudo dnf copr enable blakegardner/xremap
sudo dnf install xremap-wlroots
```

## Group permissions

xremap needs access to `/dev/input/*` (input group) and `/dev/uinput` (input group).

```bash
# Add yourself to the input group (may already exist)
sudo usermod -aG input $USER
```

Log out and back into your Sway session for group membership to take effect.

### uinput device permissions

The udev rule must use `GROUP="input"` (a system group) rather than a custom `uinput`
group. Non-system groups (GID > ~1000) are not applied reliably by udev.

```bash
# Add a udev rule so /dev/uinput is accessible by the input group on every boot
echo 'KERNEL=="uinput", GROUP="input", MODE="0660"' | sudo tee /etc/udev/rules.d/99-uinput.rules
sudo udevadm control --reload-rules && sudo udevadm trigger
```

The udev rule only applies after the `uinput` kernel module is loaded. To ensure
it loads at boot before udev runs:

```bash
echo 'uinput' | sudo tee /etc/modules-load.d/uinput.conf
```

After a reboot, verify:

```bash
ls -la /dev/uinput
# Should show: crw-rw----+ 1 root input 10, 223 ...
```

## CapsLock remapping

If you remap CapsLock to Ctrl (e.g. via `xkb_options ctrl:nocaps` in sway),
xremap operates below the compositor and sees the raw `KEY_CAPSLOCK` event —
it never sees `KEY_LEFTCTRL`. This means CapsLock-based shortcuts won't trigger
xremap's keymap rules.

The fix is to remove `ctrl:nocaps` from your sway config and handle the remap
in xremap itself using a `modmap` section. Modifier key remapping must use
`modmap`, not `keymap`, since keymap handles modifier keys differently.

```yaml
modmap:
  - name: CapsLock to Ctrl (global)
    remap:
      CapsLock: Control_L
```

Comment out or remove from your sway config:
```
# xkb_options ctrl:nocaps
```

## Config

Create `~/.config/xremap/config.yml` based on [config.yml](config.yml).

## Test manually

```bash
xremap ~/.config/xremap/config.yml
```

You should see output like:

```
Selected keyboards automatically since --device options weren't specified:
/dev/input/event1 : AT Translated Set 2 keyboard
application-client: wlroots (supported: true)
application: google-chrome
```

## Autostart with systemd

```bash
mkdir -p ~/.config/systemd/user
```

Create `~/.config/systemd/user/xremap.service` based on [systemd/user/xremap.service](../systemd/user/xremap.service)

Enable and start it:

```bash
systemctl --user daemon-reload
systemctl --user enable --now xremap
systemctl --user status xremap
```

The service must use `WantedBy=default.target` (not `graphical-session.target`,
which is not reliably activated in a sway session).

Add the following to the sway config since `WAYLAND_DISPLAY` won't be set when
the systemd user service starts:

```
exec systemctl --user import-environment WAYLAND_DISPLAY && systemctl --user restart xremap
```

This ensures xremap can connect to the Wayland compositor for application-specific
remapping (without it, the keymap rules won't fire even though the modmap still works).

## xremap resume

When the system suspends and resumes the remapping stops working in the browser.
Add a system-level service to restart xremap on resume:

```bash
sudo tee /etc/systemd/system/xremap-resume.service << EOF
[Unit]
Description=Restart xremap after resume
After=suspend.target

[Service]
Type=oneshot
User=root
ExecStart=/usr/sbin/runuser -l $USER -c 'systemctl --user import-environment WAYLAND_DISPLAY && systemctl --user restart xremap'

[Install]
WantedBy=suspend.target
EOF

sudo systemctl daemon-reload
```

Note: this is a system-level service (in `/etc/systemd/system/`), separate from
the user-level xremap service. The `$USER` variable expands from your shell when
you run the heredoc — do not use single-quoted `'EOF'` or it won't expand.
