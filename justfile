# Default recipe - show available commands
default:
    @just --list

# Build and switch to the system configuration
rebuild:
    sudo darwin-rebuild switch --flake .#aarch64-darwin --impure

# Build and switch using default configuration (auto-detects architecture)
rebuild-default:
    sudo darwin-rebuild switch --flake .#default --impure

# Check the configuration without building
check:
    sudo darwin-rebuild check --flake .#aarch64-darwin --impure

# Validate Nix syntax/evaluation without applying anything (no sudo needed)
dry-build:
    nix build .#darwinConfigurations.default.system --dry-run --impure

# Rollback to previous generation
rollback:
    sudo darwin-rebuild rollback

# Update flake inputs
flake-update:
    ulimit -n 65536; nix flake update

# Search for packages in nixpkgs
search QUERY:
    nix search nixpkgs {{QUERY}}

# Show Nix system information
info:
    nix-shell -p nix-info --run nix-info

# Verify Nix store integrity
verify:
    nix-store --verify --check-contents

# Clean up old generations and optimize store
clean:
    nix-collect-garbage -d && nix-store --optimize

# Clean up generations older than 7 days
clean-old:
    nix-collect-garbage --delete-older-than 7d
