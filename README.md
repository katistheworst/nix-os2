# 🩷 Kat's NixOS Config

Hyprland + Noctalia Shell + Stylix + Home Manager on a TUF Gaming 15

## What's Inside

| Layer | Tool |
|-------|------|
| Compositor | Hyprland |
| Shell (bar, launcher, notifs, wallpaper, lock) | Noctalia |
| Custom widgets | Eww |
| Terminal | Ghostty |
| File manager | Yazi (TUI) |
| Audio | Pipewire |
| Screenshots | Hyprshot |
| Theming | Stylix (Princess Bubblegum palette) |
| Prompt | Starship (PB powerline gradient) |
| AI coding | Claude Code |
| AI IDE | Cursor |
| AI assistant | OpenClaw (post-boot install) |
| Icons | Needy Streamer Overload |
| User config | Home Manager |
| GPU | NVIDIA (proprietary) |

## First-Time Setup

### 1. Install NixOS
Boot from the graphical USB installer. During install, the installer
generates `hardware-configuration.nix` for your specific machine.

### 2. Enable Flakes
After first boot, edit `/etc/nixos/configuration.nix` temporarily:
```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```
Then `sudo nixos-rebuild switch`.

### 3. Clone This Config
```bash
git clone https://github.com/katistheworst/nix-os2.git ~/nixos-config
cd ~/nixos-config
```

### 4. Copy Your Hardware Config
```bash
cp /etc/nixos/hardware-configuration.nix ~/nixos-config/
```
This file is unique to YOUR machine — never delete it.

### 5. Build!
```bash
sudo nixos-rebuild switch --flake ~/nixos-config#tuf
```

### 6. Reboot
```bash
reboot
```
You should land in TuiGreet → type your password → Hyprland starts
with Noctalia shell running.

## Key Binds (Hyprland)

| Key | Action |
|-----|--------|
| `Super + Return` | Ghostty terminal |
| `Super + D` | Noctalia launcher |
| `Super + E` | Yazi file manager |
| `Super + B` | Firefox |
| `Super + C` | Cursor IDE |
| `Super + Q` | Close window |
| `Super + F` | Fullscreen |
| `Super + V` | Toggle floating |
| `Super + S` | Screenshot (select area) |
| `Super + Shift + S` | Screenshot (full screen) |
| `Super + 1-9` | Switch workspace |
| `Super + Shift + 1-9` | Move window to workspace |
| `Super + hjkl/arrows` | Move focus |

## Customizing

- **Colors**: Edit the `base16Scheme` in `configuration.nix` or just
  drop a wallpaper and let Stylix auto-generate a palette from it
- **Wallpaper**: Replace the `stylix.image` path in `configuration.nix`
- **Hyprland**: Edit settings in `home.nix` under `wayland.windowManager.hyprland`
- **Eww widgets**: Edit files in `./eww/`
- **Noctalia**: Configure via its settings panel or IPC

## Useful Commands

```bash
# Rebuild after changes
rebuild          # alias defined in zsh

# Update all flake inputs
update           # alias defined in zsh

# Rollback if something breaks
sudo nixos-rebuild switch --rollback

# Claude Code (agentic coding in terminal)
cc               # alias for 'claude'

# Yazi file manager
Super + E        # opens Yazi in Ghostty
```

## Post-Boot Setup

### Zen Browser
```bash
flatpak install flathub app.zen_browser.zen
```

### OpenClaw (AI assistant gateway)
```bash
npm install -g openclaw@latest
openclaw onboard --install-daemon
# Follow prompts to set up API keys and channels
```

### Cursor IDE
Cursor is installed system-wide. If you get GPU crashes on NVIDIA:
```bash
# Run with nixGL wrapper
nix run --impure github:nix-community/nixGL -- cursor
```
Or add a zsh alias: `alias cursor='nix run --impure github:nix-community/nixGL -- cursor'`

### fGalaxy
```bash
curl -sSL https://raw.githubusercontent.com/xoodymoon/fgalaxy/main/install.sh | bash
```

## NSO Icons
Needy Streamer Overload desktop icons are deployed to `~/.local/share/icons/nso/`.
Use them in Eww widgets, Noctalia config, or custom desktop shortcuts.
Available icons include: kangel, ame, bear, discord, heart, game, folder variants, and more.

## TODO
- [x] Add wallpaper (LaserAway illustration, AI upscaled 4x)
- [ ] Set git email in home.nix
- [ ] Set Anthropic API key for Claude Code: `export ANTHROPIC_API_KEY=...`
- [ ] Configure OpenClaw channels (Telegram, Discord, etc.)
- [ ] Sign into Cursor (free tier or Pro)
- [ ] Customize Eww widgets with NSO icons
- [ ] Explore Noctalia settings panel
- [ ] Add more Hyprland window rules
