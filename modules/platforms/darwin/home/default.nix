{
  config,
  inputs,
  username,
  ...
}:

let
  # Same repo-path detection as ../../../shared/dotfiles.nix: resolves to the
  # actual clone location wherever the flake was run from, not a hardcoded path.
  repoPath =
    if builtins.hasAttr "self" inputs && inputs.self ? sourceInfo then
      inputs.self.sourceInfo.outPath
    else
      "/Users/${username}/nix-darwin";
in
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

  # macOS-specific configurations
  home.file = {
    # macOS-specific Ghostty location — needed for GUI launches (Spotlight/Dock),
    # which don't inherit $GHOSTTY_CONFIG_DIR from a login shell.
    "Library/Application Support/com.mitchellh.ghostty".source =
      config.lib.file.mkOutOfStoreSymlink "${repoPath}/dotfiles/ghostty";
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
