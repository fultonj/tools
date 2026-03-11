# Waybar

I prefer my [Waybar](https://github.com/Alexays/Waybar) at the bottom
with certain icons removed and less distracting colors.

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
        "clock"
        // "tray"
    ],
```
Note that I comment out the `tray` and remove the `,` after `clock.

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
