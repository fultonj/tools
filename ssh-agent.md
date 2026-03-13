# SSH Agent Setup for Sway/Wayland (Fedora)

## Problem

`ssh-add` fails with:

```
Could not open a connection to your authentication agent.
```

I could type `eval "$(ssh-agent -s)"` but I don't want to have to after I login to Sway.

## Solution

Use a systemd user service to start `ssh-agent` at login, with a fixed socket path exported via `~/.bashrc`.

## Setup

### 1. Create the systemd user service

`~/.config/systemd/user/ssh-agent.service`:

```ini
[Unit]
Description=SSH key agent

[Service]
Type=simple
Environment=SSH_AUTH_SOCK=%t/ssh-agent.socket
ExecStart=/usr/bin/ssh-agent -D -a $SSH_AUTH_SOCK

[Install]
WantedBy=default.target
```

### 2. Enable and start the service

```bash
systemctl --user enable --now ssh-agent.service
```

### 3. Export the socket path

Add to `~/.bashrc`:

```bash
export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"
```

This ensures the variable is available to Sway and all child processes (including tmux).

## Usage

After logging back in, add your key once per session:

```bash
ssh-add
```

The agent persists for the lifetime of the login session.
