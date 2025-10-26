# Nix-Darwin Demo Setup

A modern, declarative system configuration using Nix and Home Manager for macOS and Linux development environments.

## Why Nix over traditional dotfiles with stow?

Traditional dotfiles management typically involves:

- Platform-specific configurations that don't work across systems
- Manual dependency tracking and installation
- No rollback capability when something breaks
- Fragmented setup across multiple tools (Homebrew, Stow, scripts)
- Slow sequential installation of packages
- Inconsistent environments across machines

### Nix benefits

- Cross-platform: Same configuration works on macOS and Linux
- Declarative: Your entire system described in code
- Atomic operations: Changes either fully succeed or fail
- Easy rollbacks: Undo any change instantly
- Reproducible: Exact same environment anywhere
- Fast installation: Parallel package installation
- Unified management: Packages + dotfiles in one place

## Architecture overview

**macOS**: nix-darwin + home-manager  
**Linux**: home-manager

nix-darwin is NixOS for macOS. It provides system-level control and Homebrew integration that home-manager alone cannot provide.

```
demo-nix-darwin/
├── flake.nix                    # Main entry point - defines all configurations
├── modules/
│   ├── platforms/
│   │   ├── darwin/              # macOS-specific modules
│   │   │   ├── system/          # System-level macOS settings
│   │   │   │   ├── default.nix  # Main system config
│   │   │   │   ├── homebrew.nix # GUI apps via Homebrew
│   │   │   │   ├── packages.nix # System packages
│   │   │   │   └── system.nix   # macOS system settings
│   │   │   └── home/            # User-level macOS config
│   │   │       └── default.nix  # Home-manager integration
│   │   └── linux/               # Linux-specific configuration
│   │       └── default.nix      # Linux home-manager config
│   └── share/                   # Cross-platform modules
│       ├── dotfiles.nix         # Symlink management
│       ├── packages.nix         # Common CLI tools
│       └── programs.nix         # Program configurations
└── dotfiles/                    # Your actual dotfiles
    ├── fish/
    │   └── config.fish         # Fish shell configuration
    ├── ghostty/
    │   └── config              # Terminal emulator settings
    └── starship/
        └── starship.toml       # Prompt configuration
```

### Why use dotfiles instead of native Nix program configuration?

This setup uses traditional dotfiles (symlinked by Nix) rather than native Nix program modules. Why?

- Keep existing configs: No need to rewrite your carefully crafted configurations in Nix syntax
- Tool familiarity: Use the actual program's native config format, not Nix abstractions
- Cross-platform portability: Same dotfiles work on any system with or without Nix
- Easier migration: Drop-in compatibility with existing dotfile setups

Native Nix program modules are powerful but require learning Nix-specific syntax and may not expose all program options.

## Quick start

### Prerequisites

1. Install Nix (if not already installed):

    ```bash
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
    ```

    We recommend the [Determinate Systems installer](https://docs.determinate.systems/determinate-nix) over the official Nix installer because it provides:
    - Faster performance: Parallel evaluation can cut build times in half
    - Better macOS integration: Native Linux builder for cross-platform builds
    - Enterprise security: SOC 2 Type II validated with defined CVE process
    - Smoother experience: Automatic garbage collection and certificate management
    - Lazy trees: 3x faster evaluation and 20x less disk usage in large repos

2. Install Homebrew (macOS only):
    ```bash
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ```

### Installation

1. Clone the repository:

    ```bash
    git clone git@github.com:tduyng/demo-nix-darwin.git ~/nix-darwin
    cd ~/nix-darwin
    ```

2. Update username in flake.nix:

    ```nix
    # Find and replace in flake.nix (lines 128, 135, 142, 152, 159)
    username = "your-username";  # Replace with your actual username
    ```

3. Apply configuration:

    macOS (nix-darwin + home-manager):

    ```bash
    # First time setup
    sudo darwin-rebuild switch --flake $HOME/nix-darwin#default --impure # detect auto your system

    # Or for specific architecture
    sudo darwin-rebuild switch --flake .#aarch64-darwin  # Apple Silicon
    sudo darwin-rebuild switch --flake .#x86_64-darwin   # Intel
    # or sudo darwin-rebuild switch --flake $HOME/nix-darwin#aarch64-darwin
    ```

    Linux (home-manager only):

    ```bash
    nix run home-manager -- switch --flake .#x86_64-linux    # x86_64
    nix run home-manager -- switch --flake .#aarch64-linux   # ARM64
    ```

## What gets installed

### CLI tools & development environment

- Shell: Fish shell with Starship prompt
- Navigation: eza (better ls), zoxide (smart cd)
- Node.js: pnpm, ESLint, Prettier, fnm (Node version manager)
- Fonts: Fira Code, Nerd Fonts symbols

### GUI Applications (macOS via Homebrew)

Why use Homebrew for GUI apps?

While Nix handles CLI tools very well, macOS GUI apps need special integration that only Homebrew provides:

- Package availability - Some macOS apps only exist in Homebrew, not nixpkgs
- Spotlight search - Nix GUI apps don't appear in Spotlight
- Dock & system integration - Proper macOS behavior and notifications

Installed apps:

- Ghostty - GPU-accelerated terminal emulator

### Dotfiles automatically symlinked

- `~/.config/fish/config.fish` → `~/nix-darwin/dotfiles/fish/config.fish`
- `~/.config/ghostty/config` → `~/nix-darwin/dotfiles/ghostty/config`
- `~/.config/starship/starship.toml` → `~/nix-darwin/dotfiles/starship/starship.toml`

## Daily usage commands

### System management

```bash
# Update system configuration
sudo darwin-rebuild switch --flake ~/nix-darwin#default --impure

# Check configuration without applying
sudo darwin-rebuild check --flake ~/nix-darwin#default

# Rollback to previous generation
sudo darwin-rebuild rollback

# Update all packages
nix flake update --flake ~/nix-darwin
```

### Package management

```bash
# Search for packages
nix search nixpkgs <package-name>

# Clean old generations and optimize store
nix-collect-garbage -d && nix-store --optimize

# List installed packages
nix profile list                    # User packages
nix-env -q                         # Environment packages
```

## Customization guide

### Adding new cli tools

Edit `modules/share/packages.nix`:

```nix
home.packages = with pkgs; [
  # Existing packages...
  your-new-package
];
```

### Adding new gui apps (macos)

Edit `modules/platforms/darwin/system/homebrew.nix`:

```nix
casks = [
  # Existing casks...
  "your-new-app"
];
```

### Adding new dotfiles

1. Add your dotfile to the `dotfiles/` directory
2. Create symlink in `modules/share/dotfiles.nix`:

```nix
home.file = {
  # Existing symlinks...
  ".config/your-app".source = mkOutOfStoreSymlink "${dotfileDir}/your-app";
};
```

### Configuring programs

Edit `modules/share/programs.nix` to enable and configure programs (if necessary)

```nix
programs = {
  # Example: Enable and configure git
  git = {
    enable = true;
    userName = "Your Name";
    userEmail = "your.email@example.com";
  };
};
```

### Use aliases

The configuration includes useful Fish shell aliases for Nix management:

```fish
# System management (platform-only)
alias nix-rebuild "sudo darwin-rebuild switch --flake ~/nix-darwin#aarch64-darwin"
alias nix-rebuild-default "sudo darwin-rebuild switch --flake ~/nix-darwin#default --impure"
alias nix-check "sudo darwin-rebuild check --flake ~/nix-darwin#aarch64-darwin"
alias nix-rollback "sudo darwin-rebuild rollback"
alias home-manager "nix run home-manager --"
alias hm "nix run home-manager --"
alias hm-switch "nix run home-manager -- switch --flake ~/nix-darwin#aarch64-darwin"
alias hm-news="hm news --flake ~/nix-darwin#aarch64-darwin"
alias flake-update "nix flake update --flake $HOME/nix-darwin"

# Nix package management
alias nix-search "nix search nixpkgs"
alias nix-info "nix-shell -p nix-info --run nix-info"
alias nix-doctor "nix-store --verify --check-contents"
alias nix-clean "nix-collect-garbage -d && nix-store --optimize"
alias nix-clean-old "nix-collect-garbage --delete-older-than 7d"

# Package listing
alias nix-list "nix-env -q"
alias nix-list-system "ls /run/current-system/sw/bin | sort"
alias nix-list-user "nix profile list"
alias nix-generations "nix-env --list-generations"
```
