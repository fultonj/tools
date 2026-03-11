# Waybar

Here is how I modify by [Waybar](https://github.com/Alexays/Waybar).

```
mkdir -p ~/.config/waybar
cp /etc/xdg/waybar/config ~/.config/waybar/config 2>/dev/null || cp /etc/xdg/waybar/config.jsonc ~/.config/waybar/config
```
Modify the following in `~/.config/waybar/config`

Uncomment the following:
```
    "position": "bottom", // Waybar position (top|bottom|left|right)
```
Comment out the following (so height changes with font size)
```
    // "height": 30, // Waybar height (to be removed for auto height)
```
Comment out the following modules:
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
To change the colors and font size, copy the style sheet and edit accordingly:
```
cp /etc/xdg/waybar/style.css ~/.config/waybar/style.css
```
Here's my [waybar_style_css.diff](waybar_style_css.diff).

Restart the waybar after changing these files:
```
killall waybar && waybar &
```
