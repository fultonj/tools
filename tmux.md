# How I use tmux

I used to use [tmux](https://github.com/tmux/tmux/wiki) just to:

- keep a long running shell on a server after I logged out
- share a terminal on a server with collaborators

I also used to use lots of instances of the terminal
(e.g. `xfce4-terminal`) on my laptop.

I'm now using a local tmux on my laptop just in _one_
`xfce4-terminal` with lots of different windows and panes.
tmux has become like a window manager for me but only for
terminals.

When I SSH into servers I nest tmux and I don't have a problem
doing that becuase I just use a different prefix. I keep the
default `Ctrl-b` prefix since I don't want to have to customize
it on servers. I customize my local tmux however and bind the prefix
to `Ctrl-j`.

## catppuccin

I follow these steps directly from
[catppuccin/tmux](https://github.com/catppuccin/tmux?tab=readme-ov-file#manual-recommended).

Download `catppuccin/tmux`
```
mkdir -p ~/.config/tmux/plugins/catppuccin
git clone -b v2.1.3 https://github.com/catppuccin/tmux.git ~/.config/tmux/plugins/catppuccin/tmux
```
Add the following to `~/.tmux.conf`
```
run ~/.config/tmux/plugins/catppuccin/tmux/catppuccin.tmux
```
Reload tmux
```
tmux source ~/.tmux.conf
```

## config

- Here is my [~/.tmux.conf](config/dot_tmux.conf)
- I borrowed from [omerxx/dotfiles](https://github.com/omerxx/dotfiles/blob/master/tmux/tmux.conf)
