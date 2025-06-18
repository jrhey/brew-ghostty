#!/bin/bash

# Development Environment Setup Script
# This script sets up your complete development environment including Neovim, Homebrew packages, and configurations

set -e # Exit on error

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
  echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
  echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
  echo -e "${RED}[ERROR]${NC} $1"
}

# Function to create backup with timestamp
create_backup() {
  local source=$1
  local backup_name=$2

  if [ -e "$source" ]; then
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_path="${source}.${backup_name}.${timestamp}"

    print_info "Backing up $source to $backup_path"
    mv "$source" "$backup_path"
    print_info "Backup created: $backup_path"
  else
    print_info "No existing $source found, skipping backup"
  fi
}

# Function to check if command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Installation modes
install_homebrew_packages() {
  print_info "Installing Homebrew packages..."
  
  if ! command_exists brew; then
    print_error "Homebrew is not installed. Please install it first:"
    echo "Visit: https://brew.sh"
    return 1
  fi
  
  if [ -f "$SCRIPT_DIR/Brewfile" ]; then
    print_info "Installing packages from Brewfile..."
    brew bundle --file="$SCRIPT_DIR/Brewfile"
  else
    print_error "Brewfile not found in $SCRIPT_DIR"
    return 1
  fi
}

install_nvim_config() {
  print_info "Installing Neovim configuration..."
  
  # Create backup if exists
  create_backup "$HOME/.config/nvim" "bak"
  
  # Ensure config directory exists
  mkdir -p "$HOME/.config"
  
  # Copy nvim config from repo
  if [ -d "$SCRIPT_DIR/nvim" ]; then
    print_info "Copying Neovim configuration..."
    cp -r "$SCRIPT_DIR/nvim" "$HOME/.config/"
    print_info "Neovim configuration installed successfully"
  else
    print_error "nvim directory not found in $SCRIPT_DIR"
    return 1
  fi
}

setup_symlinks() {
  print_info "Setting up symlinks for development..."
  
  # Remove existing nvim config
  if [ -e "$HOME/.config/nvim" ]; then
    print_warning "Removing existing nvim config to create symlink"
    rm -rf "$HOME/.config/nvim"
  fi
  
  # Create symlink
  ln -sf "$SCRIPT_DIR/nvim" "$HOME/.config/nvim"
  print_info "Symlink created: ~/.config/nvim -> $SCRIPT_DIR/nvim"
}

# Main installation process
main() {
  print_info "Starting Development Environment Setup"
  echo ""
  
  # Check for required dependencies
  print_info "Checking dependencies..."
  
  if ! command_exists git; then
    print_error "Git is not installed. Please install git first."
    exit 1
  fi
  
  # Show installation options
  echo "This script can:"
  echo "  1. Install all (Homebrew packages + Neovim config)"
  echo "  2. Install Homebrew packages only"
  echo "  3. Install Neovim config only"
  echo "  4. Setup development symlinks (for working on configs)"
  echo ""
  read -p "Choose an option (1-4): " -n 1 -r
  echo ""
  
  case $REPLY in
    1)
      print_info "Installing everything..."
      install_homebrew_packages
      install_nvim_config
      ;;
    2)
      install_homebrew_packages
      ;;
    3)
      install_nvim_config
      ;;
    4)
      setup_symlinks
      ;;
    *)
      print_error "Invalid option"
      exit 1
      ;;
  esac
  
  echo ""
  print_info "Setup completed!"
  echo ""
  echo "Next steps:"
  echo "  - Start Neovim: nvim"
  echo "  - Neovim will automatically install plugins on first run"
  echo "  - Your configs are now tracked in this git repository"
  echo ""
  
  # Show backups if any were created
  if find "$HOME/.config" -maxdepth 1 -name "nvim.bak.*" -type d 2>/dev/null | grep -q .; then
    echo "Backups available:"
    find "$HOME/.config" -maxdepth 1 -name "nvim.bak.*" -type d 2>/dev/null | head -5
  fi
}

# Run main function
main "$@"
