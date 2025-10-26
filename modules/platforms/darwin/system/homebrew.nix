{ ... }:

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
      cleanup = "none"; # none | check | uninstall | zap
      autoUpdate = true;
      upgrade = true;
    };
  };
}
