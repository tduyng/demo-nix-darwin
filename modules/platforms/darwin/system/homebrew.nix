{ config, pkgs, ... }:

{
  homebrew = {
    enable = true;

    brews = [
    ];

    casks = [
      # Terminals
      "ghostty"

      # Development tools
      # "visual-studio-code"
    ];

    # Custom taps
    taps = [
    ];

    onActivation = {
      cleanup = "none"; # none | uninstall | zap --> recommand to use "zap"
      autoUpdate = true;
      upgrade = true;
    };
  };
}
