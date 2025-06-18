# Development Environment Setup

This repository contains my complete development environment configuration, including Neovim setup, Homebrew packages, and other dotfiles.

## Quick Start

Clone this repository and run the install script:

```bash
git clone <your-repo-url> ~/Developer/brew-ghostty
cd ~/Developer/brew-ghostty
./install.sh
```

## Installation Options

The install script provides several options:

1. **Install all** - Installs Homebrew packages and Neovim configuration
2. **Homebrew packages only** - Installs packages defined in `Brewfile`
3. **Neovim config only** - Installs the Neovim configuration
4. **Development symlinks** - Creates symlinks for active config development

## Structure

```
.
├── Brewfile        # Homebrew packages
├── install.sh      # Installation script
├── nvim/           # Neovim configuration
│   ├── init.lua
│   ├── lua/
│   │   ├── config/
│   │   └── plugins/
│   └── ...
└── README.md       # This file
```

## Updating

To update your local configuration after making changes to this repo:

```bash
git pull
./install.sh
```

Choose option 3 to update just Neovim config, or option 1 to update everything.

## Development Mode

If you're actively working on your configs, use option 4 to create symlinks. This way, changes in the repo are immediately reflected in your system:

```bash
./install.sh
# Choose option 4
```

## Backups

The install script automatically creates timestamped backups of your existing configurations before overwriting them. Backups are stored as:
- `~/.config/nvim.bak.YYYYMMDD_HHMMSS`

## Adding New Configurations

To add more dotfiles:
1. Create a new directory (e.g., `config/ghostty/`)
2. Add your configuration files
3. Update `install.sh` to handle the new configs
4. Commit and push