#!/bin/zsh
# Backup script for dotfiles

# Set the dotfiles directory
DOTFILES_DIR="$HOME/.dotfiles"
CONFIG_DIR="$HOME/.config"

# Set colors for output
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "${GREEN}Backing up dotfiles...${NC}"

# Backup nix configuration
echo "${YELLOW}Backing up nix configuration...${NC}"
cp "$CONFIG_DIR/nix/flake.nix" "$DOTFILES_DIR/nix/"
echo "${GREEN}✓ Nix configuration backed up${NC}"

# Backup p10k configuration
echo "${YELLOW}Backing up Powerlevel10k...${NC}"
mkdir -p "$DOTFILES_DIR/zsh"
cp "$HOME/.p10k.zsh" "$DOTFILES_DIR/zsh/.p10k.zsh"
echo "${GREEN}✓ Powerlevel10k configuration backed up${NC}"

# Backup ghostty configuration
echo "${YELLOW}Backing up Ghostty terminal...${NC}"
cp "$CONFIG_DIR/ghostty/config" "$DOTFILES_DIR/ghostty/"
echo "${GREEN}✓ Ghostty configuration backed up${NC}"

echo ""
echo "${GREEN}Backup complete!${NC}"
echo ""
echo "${YELLOW}Next steps:${NC}"
echo "1. Navigate to your dotfiles directory:"
echo "   cd $DOTFILES_DIR"
echo ""
echo "2. Commit and push your changes:"
echo "   git add ."
echo "   git commit -m \"Update dotfiles\""
echo "   git push"
echo ""
