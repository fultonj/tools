# Fedora

I used v42 (Adams) of the
[Fedora i3 spin](https://fedoraproject.org/spins/i3)
at the time I wrote this.

## Hardware

- Lenovo ThinkPad X1 Carbon Gen 12, model 21KDS27P00
- Intel(R) Core(TM) Ultra 7 165U (14 CPUs)
- 32 GB RAM

## Install

Boot from [Fedora i3 spin](https://fedoraproject.org/spins/i3).
Do a live install with an encrypted root disk and reboot.

## Enable Verbose Boot

```
sudo grubby --update-kernel=ALL --remove-args="rhgb quiet"
```
Confirm arguments were removed.
```
sudo grubby --info=ALL | sed -n 's/^args=//p'
```

## LightDM

Update the [LightDM](https://en.wikipedia.org/wiki/LightDM) login
screen configuration file `/etc/lightdm/lightdm-gtk-greeter.conf`
to comment out the background image and set a background color
in its place.

```
  50   │ [greeter]
  51   │ # background=/usr/share/backgrounds/default.jxl
  52   │ background=#585858
```

## i3

I usually use just three workspaces in the following order:

- chrome running [tab groups](https://blog.google/products/chrome/manage-tabs-with-google-chrome)
- xfce4-terminal running [tmux](tmux.md)
- emacs running [multiple buffers](https://www.gnu.org/software/emacs/manual/html_node/emacs/Buffers.html)

My muscle memory just goes to one of the above with mod-{1,2,3}.
Then inside any of them I use an additonal abstraction (tab
groups, tmux or buffers) to manage multiple instances.

My [~/.config/i3/config](config/i3/config)
is based on the default with the following additions:

- make capslock another control key
- set the background to dark grey
- start autokey

## autokey

```
sudo dnf install autokey-gtk
```

I use [autokey](https://github.com/autokey/autokey)
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

AutoKey intercepts the key strokes at the input layer and can
prevent Chrome from ever seeing them. It can also do this based
on a window filter so I can have it translate a key combination
to something else only for Chrome windows. 

[~/.config/autokey](config/autokey)

I used to just start Chrome with something like this:
```
Exec=env GTK_KEY_THEME=Emacs google-chrome-stable %U
```
Unfortunately Chromium 116+ no longer respects gtk-key-theme-name
setting: https://issues.chromium.org/issues/40279679 so I use autokey.

## Brightness

`brightnessctl` will be installed by default. Dim the screen 10% as
many times as needed.
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

## xfce4-terminal

The `i3-sensible-terminal` in the i3 spin is xfce4-terminal.

- Preferences
  - General 
    - Check Automatically copy selection to clipboard
    - Uncheck show unsafe paste dialog
  - Appearance
    - Uncheck "Use System Font"
    - Search for "JetBrainsMono" to sent a nerd font
  - Colors
    - Preset "green on black"
  - Advanced
    - Uncheck "Enable menu access keys (such as Alt+F to open the File menu)".

## tmux

See [tmux.md](tmux.md).

## Emacs

```
sudo dnf install emacs-lucid
```
My [~/.Xresources](config/dot_Xresources)
is to configure only the look of emacs.
i3 already sources `~/.Xresources` on startup.
I only run `xrdb -merge ~/.Xresources` if I change it.
I am not including my `~/elisp/` and `.emacs` here for now.

## Monitors

I used to use three external monitors. Now I just use one. I use
`arandr` to make it easy to switch between my laptop screen and an
external monitor.
```
sudo dnf install arandr
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
sudo dnf install mupdf htop iftop rpm-build xset
```
