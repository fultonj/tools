# Fedora

I used v42 (Adams) of the
[Fedora i3 spin](https://fedoraproject.org/spins/i3)
when I initially wrote this. That version of this repo is tagged
[fedora42](https://github.com/fultonj/tools/blob/fedora42/fedora.md).

I have since upgraded to Fedora 43 and did the switched
to [Sway](https://swaywm.org) with [Wayland](https://wayland.freedesktop.org/).

## Hardware

- Lenovo ThinkPad X1 Carbon Gen 12, model 21KDS27P00
- Intel(R) Core(TM) Ultra 7 165U (14 CPUs)
- 32 GB RAM

## Sway

I usually use just three workspaces in the following order:

- chrome running [tab groups](https://blog.google/products/chrome/manage-tabs-with-google-chrome)
- a terminal running [tmux](tmux.md)
- emacs running [multiple buffers](https://www.gnu.org/software/emacs/manual/html_node/emacs/Buffers.html)

My muscle memory just goes to one of the above with mod-{1,2,3}.
Then inside any of them I use an additonal abstraction (tab
groups, tmux or buffers) to manage multiple instances.

My [~/.config/sway/config](config/sway/config)
was converted from my i3 config.

```
sudo dnf install sway waybar wofi
```

## Waybar

I prefer my [Waybar](https://github.com/Alexays/Waybar)
at the bottom. It only required one modification to the
default config so I'll share the steps, not the full
config.

```
mkdir -p ~/.config/waybar
cp /etc/xdg/waybar/config ~/.config/waybar/config 2>/dev/null || cp /etc/xdg/waybar/config.jsonc ~/.config/waybar/config
```
Uncomment the following line in `~/.config/waybar/config`/

```
"position": "bottom", // Waybar position (top|bottom|left|right)
```
I like to comment out the following modules:
```
    "modules-right": [
        // "idle_inhibitor",
        // "pulseaudio",
        // "network",
        "power-profiles-daemon",
        "cpu",
        "memory",
        // "temperature",
        // "backlight",
        // "sway/language",
        "battery",
        "clock",
        "tray"
    ],
```
I also set the center modules to the following:
```
    "modules-center": [],
```
To change the colors copy them in and edit accordingly:
```
cp /etc/xdg/waybar/style.css ~/.config/waybar/style.css
```
Here's my [waybar_style_css.diff](waybar_style_css.diff).

Restart the waybar after changing these files:
```
killall waybar && waybar &
```

## swaylock
In my .bashrc (old habits die hard)
```
alias xlock='swaylock -c 000000'
```

## xremap on sway

I use [xremap](https://github.com/xremap/xremap)
on Wayland to implement the following key bindings in Chrome.
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
See [my xremap config](config/xremap/) for details.

## Foot

I am now using
[foot terminal](https://codeberg.org/dnkl/foot#why-the-name-foot)
with this [foot.ini](config/foot/foot.ini).

## Brightness

I use `brightnessctl` to control the screen brightness.

For example, dim the screen 10% as many times as needed.
```
brightnessctl set 10%-
```

## Network

I connect to my company VPN and other networks wtih `nmtui`
```
sudo dnf install nmtui
```

## Nerd Fonts

These are fonts that have been patched with extra glyphs and symbols.
[catppuccin/tmux](https://github.com/catppuccin/tmux) requires these
so that its extra status symbols do not show up as squares.

```
mkdir -p ~/.local/share/fonts/NerdFonts && cd ~/.local/share/fonts/NerdFonts
curl -L -o JetBrainsMono.zip \
  https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
unzip -o JetBrainsMono.zip
fc-cache -f
```

## tmux

See [tmux.md](tmux.md).

## Emacs

```
sudo dnf install emacs
```

I have the following in my `.emacs` to control the colors and font.
```lisp
;; Appearance — faces are the canonical place for colors and fonts
(set-face-attribute 'default nil :font "JetBrainsMono Nerd Font-14" :foreground "#00FF00" :background "#000000")
(set-face-attribute 'cursor  nil :background "lime")
(set-face-attribute 'mouse   nil :foreground "red")
(set-face-attribute 'region  nil :foreground "black" :background "yellow")
```
I am not including my `~/elisp/` and `.emacs` here for now.

## Monitors

I used to use three external monitors. Now I just use one. I use
[wlr-randr](https://gitlab.freedesktop.org/emersion/wlr-randr)
to make it easy to switch between my laptop screen and an
external monitor.
```
sudo dnf install wlr-randr
```
I confiure two scripts which I symlink from `~/bin`:

- [1-mon-at-home.sh](bin/1-mon-at-home.sh) for when I dock
- [laptop-screen.sh](bin/laptop-screen.sh) for when I undock

## IronKey

I unlock and lock my
[IronKey](https://en.wikipedia.org/wiki/IronKey)
with [~/bin/iron](bin/iron) which requires:
```
sudo dnf install libgcc.i686 glibc.i686
sudo mkdir /mnt/iron{,-iso}
```
The above works with my
Imation Basic D250 Flash Drive (D2-D250-B08-3FIPS).

## Packages

Other packages
```
sudo dnf install mupdf htop iftop rpm-build
```
## OpenShift

See [openshift.md](openshift.md)
