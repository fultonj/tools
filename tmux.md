# How I use tmux

I used to only use [tmux](https://github.com/tmux/tmux/wiki) to:

- keep a long running shell on a server after I logged out
- share a terminal on a server with collaborators

I would not run tmux directly on my laptop and I would use many terminal instances.

Now my approach to tmux is the following:

- Use tmux like a window manager for terminals
- Run _one_ `xfce4-terminal` with many tmux windows and panes
- Do not customize tmux on servers; keep using the `Ctrl-b` prefix
- Customize tmux prefix on my laptop; use the `Ctrl-j` prefix so I can nest

## Tmux Plugin Manager (TPM)

I use [TPM](https://github.com/tmux-plugins/tpm) to mange tmux plugins.

Follow the
[TPM installation](https://github.com/tmux-plugins/tpm?tab=readme-ov-file#installation)
steps.

## catppuccin/tmux

I use
[catppuccin/tmux](https://github.com/catppuccin/tmux/blob/main/README.md)
to make tmux look nice.

Add the following to `~/.tmux.conf`
```
set -g @plugin 'catppuccin/tmux'
```
Source the tmux file
```
tmux source ~/.tmux.conf
```
Inside of tmux run the following to ensure the listed `@plugin` is installed.
```
prefix + I
```
My catppuccin settings can be seen in my `~/.tmux.conf`.

## ~/.tmux.conf

Here is my [~/.tmux.conf](config/dot_tmux.conf)
