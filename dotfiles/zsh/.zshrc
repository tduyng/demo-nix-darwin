# ──────────────────────────────────────────────────────────────────────────────
# Load Nix-Darwin / Home-Manager session paths in Zsh
# ──────────────────────────────────────────────────────────────────────────────

# This sets up /run/current-system/sw/bin, ~/.nix-profile/bin, 
#   and /nix/var/nix/profiles/default/bin on your PATH
if [ -e /run/current-system/sw/etc/profile.d/nix.sh ]; then
  . /run/current-system/sw/etc/profile.d/nix.sh
fi

# Home-Manager’s sessionPath, if you defined it in home.sessionPath
if [ -e "$HOME/.nix-profile/etc/profile.d/hm-session-path.sh" ]; then
  . "$HOME/.nix-profile/etc/profile.d/hm-session-path.sh"
fi

export EDITOR="nvim"
export VISUAL=nvim
export PATH="$HOME/.deno/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$HOME/.cargo/bin:$PATH"
export ZVM_INSTALL="$HOME/.zvm/self"
export PATH="$PATH:$HOME/.zvm/bin"
export PATH="$PATH:$ZVM_INSTALL/"
export PATH="/usr/local/opt/llvm/bin:$PATH"
export PATH="$HOME/zls/zig-out/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="/bin:$PATH"
export PATH="/run/current-system/sw/bin:$PATH"
export PATH="$HOME/.nix-profile/bin:$PATH"
export PATH="/nix/var/nix/profiles/default/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"
export PATH="$PATH:$HOME/.local/bin"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export QUICK=1
export DOCKER_BUILDKIT=1

# Setup custom config files
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
export DENO_INSTALL="$HOME/.deno"
export ZVM_INSTALL="$HOME/.zvm/self"
export BUN_INSTALL="$HOME/.bun"
export GOPATH="$HOME/go"
export GHOSTTY_CONFIG_DIR="$HOME/.config/ghostty"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

# ----------------------------------------
#               ALIASES
# ----------------------------------------

# General aliases
alias v="nvim"
alias vi="nvim"
alias vim="nvim"
alias vti="NVIM_APPNAME=nvim-tiny nvim"
alias vtiny="NVIM_APPNAME=nvim-tiny nvim"
alias vitiny="NVIM_APPNAME=nvim-tiny nvim"
alias vimtiny="NVIM_APPNAME=nvim-tiny nvim"
alias cl="clear"
alias gty="ghostty"

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
alias resetfish="source ~/.config/fish/config.fish"
alias resetzsh="source ~/.zshrc"
alias sys="system_profiler SPHardwareDataType SPSoftwareDataType"

#-----------------------------------------------------------------------
#                 EVAL
#-----------------------------------------------------------------------
if command -v go >/dev/null 2>&1; then
    export GOPATH=$(go env GOPATH)
    export GOROOT=$(go env GOROOT)
fi

# Starship prompt (now starship command will be found)
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi

# Node version manager
if command -v fnm >/dev/null 2>&1; then
    eval "$(fnm env --use-on-cd)"
fi

# Zoxide (smart cd)
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

# Activate vim mode in zsh shell
# bindkey -v
# source "$HOME/zsh-vim-mode/zsh-vim-mode.plugin.zsh"
# VIM_MODE_ESC_PREFIXED_WANTED='^?^Hbdfhul.g'
# bindkey -rpM viins '^[^['

# =============================================================================
# NIX ALIASES & FUNCTIONS
# =============================================================================

# System management
alias rebuild="sudo darwin-rebuild switch --flake ~/nix-darwin#default --impure"
alias rebuild-check="sudo darwin-rebuild check --flake ~/nix-darwin#default --impure"
alias rebuild-rollback="sudo darwin-rebuild rollback"
alias flake-update="nix flake update --flake ~/nix-darwin"

# Nix package management
alias nix-search="nix search nixpkgs"
alias nix-info="nix-shell -p nix-info --run nix-info"
alias nix-doctor="nix-store --verify --check-contents"
alias nix-clean="nix-collect-garbage -d && nix-store --optimize"
alias nix-clean-old="nix-collect-garbage --delete-older-than 7d"

# Package listing
alias nix-list="nix-env -q"
alias nix-list-system="ls /run/current-system/sw/bin | sort"
alias nix-list-user="nix profile list"
alias nix-generations="nix-env --list-generations"
