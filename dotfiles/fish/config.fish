# ----------------------------------------
#               ENVIRONMENT
# ----------------------------------------

set -g fish_greeting # Not greeting line when init fish shell

# Neovim and Paths
set -Ux EDITOR nvim
set -Ux VISUAL nvim
set -g fish_key_bindings fish_vi_key_bindings
set -g fish_cursor_default block
set -g fish_cursor_insert line
set -g fish_cursor_visual underscore

# Setup custom config files
set -gx STARSHIP_CONFIG "$HOME/.config/starship/starship.toml"
set -Ux GHOSTTY_CONFIG_DIR "$HOME/.config/ghostty"
set -Ux XDG_CONFIG_HOME "$HOME/.config"
set -Ux XDG_DATA_HOME "$HOME/.local/share"
set -Ux XDG_CACHE_HOME "$HOME/.cache"
set -Ux XDG_STATE_HOME "$HOME/.local/state"

# Extend PATH
set -U fish_user_paths \
    $HOME/bin \
    /opt/homebrew/bin \
    $HOME/.local/bin \
    /run/current-system/sw/bin \
    $HOME/.nix-profile/bin \
    nix/var/nix/profiles/default/bin \
    $fish_user_paths

# ----------------------------------------
#               ALIASES
# ----------------------------------------

# General aliases
alias vi="nvim"
alias vim="nvim"

# Git
alias g="git"
alias gc="git commit -m"
alias gca="git commit --amend -m"
alias gp="git push origin HEAD"
alias gpu="git pull origin"
alias gpf="git push --force-with-lease"
alias gst="git status"
alias gs="git switch"
alias gsc="git switch -c"
alias glog="git log --graph --date=relative --pretty=tformat:'%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%an %ad)%Creset' -n 20"
alias glogs="git log --graph --date=relative --pretty=tformat:'%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%an %ad)%Creset'"
alias gdiff="git diff"
alias gco="git checkout"
alias gcob="git checkout -b"
alias gb="git branch"
alias gba="git branch -a"
alias gadd="git add"
alias ga="git add -p"
alias gre="git reset"

alias pnpm="pnpm --silent"

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# Eza and File Operations
alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions -a"
alias ll="eza -lg --icons=always"
alias la="eza -lag --icons=always"
alias lt="eza -lT --icons=always --no-filesize --no-time --no-user --no-permissions"
alias lt2="eza -lT --level=2 --icons=always --no-filesize --no-time --no-user --no-permissions"
alias lt3="eza -lT --level=3 --icons=always --no-filesize --no-time --no-user --no-permissions"
alias lt4="eza -lT --level=4 --icons=always --no-filesize --no-time --no-user --no-permissions"
alias lta="eza -lTa --icons=always --no-filesize --no-time --no-user --no-permissions --git-ignore --no-git"
alias lta2="eza -lTa --level=2 --icons=always --no-filesize --no-time --no-user --no-permissions --git-ignore --no-git"
alias lta3="eza -lTa --level=3 --icons=always --no-filesize --no-time --no-user --no-permissions --git-ignore --no-git"
alias lta4="eza -lTa --level=4 --icons=always --no-filesize --no-time --no-user --no-permissions --git-ignore --no-git"

# Shortened commands
alias sc="source ~/.config/fish/config.fish"
alias resetfish="source ~/.config/fish/config.fish"
alias resetzsh="source ~/.zshrc"
# ----------------------------------------
#               EXPORTS
# ----------------------------------------
# History Configuration
set -g fish_history_max 1000

# ----------------------------------------
#               PLUGIN EVAL
# ----------------------------------------
if command -v starship >/dev/null
    starship init fish | source
end

if command -v zoxide >/dev/null
    zoxide init fish | source
end

if command -v fnm >/dev/null
   fnm env --use-on-cd --shell fish | source >/dev/null 2>&1
end

# =============================================================================
# NIX ALIASES & FUNCTIONS
# =============================================================================

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
