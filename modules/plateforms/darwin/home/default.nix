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
    ../../../shared/packages.nix
    ../../../shared/programs.nix
    ../../../shared/dotfiles.nix
  ];

  home = {
    inherit username;
    homeDirectory = "/Users/${username}";
    stateVersion = "25.05";
  };

  # macOS-specific environment variables
  home.sessionVariables = {
    TERMINAL = "ghostty";
  };

  # macOS-specific session paths
  home.sessionPath = [
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
  ];
}
