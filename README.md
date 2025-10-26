# Nix-Darwin Demo Setup

A minimal, declarative macOS (and Linux) dev environment using
[nix-darwin](https://github.com/nix-darwin/nix-darwin) and
[home-manager](https://github.com/nix-community/home-manager). Packages,
dotfiles, and macOS settings are all described in this one repo and applied
together, instead of juggling Homebrew, symlink scripts, and manual installs
separately.

Clone it, try it safely (see below), then edit it to match what you want
installed.

## Is this safe to try?

Yes, with one caveat: the `switch` step at the end does modify your system.
It installs the packages listed below, sets fish as your login shell, and
installs Ghostty via Homebrew. It does not touch your existing files or
delete unrelated apps. Every change is a generation, so you can undo it
instantly with `darwin-rebuild rollback`.

The steps below check first, then apply. The check step makes no changes at
all.

## Quick start

### 1. Install Nix (skip if you already have it)

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

macOS also needs Homebrew (skip if you already have it):

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. Clone

```bash
git clone git@github.com:tduyng/demo-nix-darwin.git ~/nix-darwin
cd ~/nix-darwin
```

No username edit needed. The flake auto-detects your username at build time.

### 3. Check first (no changes made)

```bash
sudo darwin-rebuild check --flake .#default --impure
```

If this fails, nothing on your machine has changed. Fix the error and run it
again.

### 4. Apply

```bash
sudo darwin-rebuild switch --flake .#default --impure
```

This is the step that actually changes your system: it installs everything
listed below and sets fish as your login shell.

### Undo

```bash
sudo darwin-rebuild rollback
```

### Linux

Linux has no system-level step, just home-manager:

```bash
nix run home-manager -- switch --flake .#x86_64-linux    # or .#aarch64-linux
```

## What gets installed

**CLI tools**: neovim, eza, zoxide, fish, starship, fnm, pnpm, eslint,
prettier, Fira Code + Nerd Font symbols.

**GUI apps (macOS, via Homebrew)**: Ghostty.

**Dotfiles**, symlinked from `dotfiles/` (edit them directly, then run
`switch` again to pick up changes):

- `~/.config/fish/config.fish`
- `~/.config/starship/starship.toml`
- `~/.config/ghostty/config`
- `~/.zshrc`

## Customization

Add a CLI tool in `modules/shared/packages.nix`:

```nix
home.packages = with pkgs; [
  # existing packages...
  your-new-package
];
```

Add a macOS GUI app in `modules/platforms/darwin/system/homebrew.nix`:

```nix
casks = [
  # existing casks...
  "your-new-app"
];
```

Add a dotfile: drop the file under `dotfiles/your-app/`, then symlink it in
`modules/shared/dotfiles.nix`:

```nix
home.file = {
  # existing symlinks...
  ".config/your-app".source = mkOutOfStoreSymlink "${dotfileDir}/your-app";
};
```

## Layout

```
demo-nix-darwin/
├── flake.nix          # entry point, defines all configurations
├── modules/
│   ├── platforms/
│   │   ├── darwin/    # macOS: system settings, Homebrew, packages, home-manager
│   │   └── linux/     # Linux: home-manager only
│   └── shared/        # packages, programs, dotfile symlinks used on both
└── dotfiles/          # your actual dotfiles, symlinked in by shared/dotfiles.nix
```
