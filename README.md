# Naveed's Mac Configuration

This repository contains my personal Mac configuration files managed with nix-darwin and other dotfiles.

## What's Included

- **Nix Configuration**: Managed with nix-darwin and flakes
- **Terminal Configuration**:
  - ZSH with Powerlevel10k theme
  - Ghostty terminal configuration
- **Development Tools**:
  - Neovim
  - Tmux
  - Micromamba for Python/ML environments

## Setup on a New Mac

### Prerequisites

1. Install Xcode Command Line Tools:
   ```bash
   xcode-select --install
   ```

2. Install Nix package manager:
   ```bash
   sh <(curl -L https://nixos.org/nix/install) --daemon
   ```

3. Install nix-darwin:
   ```bash
   nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
   ./result/bin/darwin-installer
   ```

### Setup Process

1. Clone this repository:
   ```bash
   git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/.dotfiles
   ```

2. Run the setup script:
   ```bash
   cd ~/.dotfiles
   ./setup.sh
   ```

3. Build the system configuration:
   ```bash
   mkdir -p ~/.config/nix
   cp ~/.dotfiles/nix/flake.nix ~/.config/nix/
   cd ~/.config/nix
   sudo darwin-rebuild switch --flake .#air
   ```

## Manual Customization

Some things might need manual customization after the initial setup:

1. **Hostname**: The configuration is set for a host named "air". If your Mac has a different hostname, edit the flake.nix file:
   ```
   darwinConfigurations."YOUR_HOSTNAME" = ...
   ```

2. **Username**: The configuration is set for user "naveedwani". If your username is different, edit the username variable in flake.nix.

## Updating Configuration

1. Make changes to the files in ~/.config/nix
2. Copy changes back to the dotfiles repository:
   ```bash
   cp ~/.config/nix/flake.nix ~/.dotfiles/nix/
   cp ~/.p10k.zsh ~/.dotfiles/zsh/
   cp ~/.config/ghostty/config ~/.dotfiles/ghostty/
   ```
3. Commit and push changes to GitHub.

## Rebuilding Your System

After making changes to the nix configuration:

```bash
cd ~/.config/nix
sudo darwin-rebuild switch --flake .#air
```
