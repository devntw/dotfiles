#!/bin/zsh
# Setup script for dotfiles

# Set the dotfiles directory
DOTFILES_DIR="$HOME/.dotfiles"
CONFIG_DIR="$HOME/.config"

# Set colors for output
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "${GREEN}Setting up dotfiles...${NC}"

# Create necessary directories
mkdir -p "$CONFIG_DIR/nix"
mkdir -p "$CONFIG_DIR/ghostty"

# Copy nix configuration
echo "${YELLOW}Setting up nix configuration...${NC}"
cp "$DOTFILES_DIR/nix/flake.nix" "$CONFIG_DIR/nix/"
echo "${GREEN}✓ Nix configuration copied${NC}"

# Copy p10k configuration
echo "${YELLOW}Setting up Powerlevel10k...${NC}"
cp "$DOTFILES_DIR/zsh/.p10k.zsh" "$HOME/"
echo "${GREEN}✓ Powerlevel10k configuration copied${NC}"

# Copy ghostty configuration
echo "${YELLOW}Setting up Ghostty terminal...${NC}"
cp "$DOTFILES_DIR/ghostty/config" "$CONFIG_DIR/ghostty/"
echo "${GREEN}✓ Ghostty configuration copied${NC}"

echo ""
echo "${GREEN}Dotfiles setup complete!${NC}"
echo ""
echo "${YELLOW}Next steps:${NC}"
echo "1. Navigate to your nix configuration directory:"
echo "   cd $CONFIG_DIR/nix"
echo ""
echo "2. Build your system configuration:"
echo "   sudo darwin-rebuild switch --flake .#air"
echo ""
echo "3. If your hostname is not 'air' or username is not 'naveedwani',"
echo "   edit the flake.nix file to match your system."
echo ""
