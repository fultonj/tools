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

xremap is a key remapper for Wayland that supports application-specific remapping.
This guide sets it up to translate GNU Emacs-style keybindings to CUA equivalents in Chrome.

## Install

```bash
sudo dnf copr enable blakegardner/xremap
sudo dnf install xremap-wlroots
```

## Group permissions

xremap needs access to `/dev/input/*` (input group) and `/dev/uinput` (uinput group).

```bash
# Add yourself to the input group (may already exist)
sudo usermod -aG input $USER

# Create uinput group and add yourself
sudo groupadd uinput
sudo usermod -aG uinput $USER

# Add a udev rule so /dev/uinput permissions survive reboots
echo 'KERNEL=="uinput", GROUP="uinput", MODE="0660"' | sudo tee /etc/udev/rules.d/99-uinput.rules
sudo udevadm control --reload-rules && sudo udevadm trigger
```

Log out and back into your Sway session for group membership to take effect.

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
