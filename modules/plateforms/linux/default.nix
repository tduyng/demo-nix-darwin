{
  config,
  lib,
  pkgs,
  inputs,
  username,
  ...
}:

{
  imports = [
    # Core shared modules
    ../../shared/packages.nix
    ../../shared/programs.nix
    ../../shared/dotfiles.nix
  ];

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.05";
  };

  # CRITICAL: Enable non-NixOS Linux support
  targets.genericLinux.enable = true;

  # Enable font management for Linux
  fonts.fontconfig.enable = true;

  # Linux-specific packages
  home.packages = with pkgs; [
    # Clipboard utilities
    xclip # X11 clipboard
    wl-clipboard # Wayland clipboard

    # System utilities
    procps # ps, top, etc
    util-linux # Linux utilities

    # File managers and desktop integration
    xdg-utils # xdg-open, etc

    # Additional Linux utilities
    findutils # find, xargs, etc
    glibc # for locale support
  ];

  # Linux-specific environment variables
  home.sessionVariables = {
    # XDG directories
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_STATE_HOME = "$HOME/.local/state";

    TERMINAL = "ghostty";

    # Ensure locale is set
    LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
  };

  # Linux-specific session paths
  home.sessionPath = [
    "/usr/local/bin"
    "/usr/bin"
    "/bin"
    "/sbin"
    "/usr/sbin"
  ];

  # Shell integration for non-NixOS systems
  programs.bash = {
    enable = true;
  };

  # Note: We don't enable programs.zsh here because dotfiles.nix manages .zshrc
}
