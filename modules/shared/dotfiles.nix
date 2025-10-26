{
  config,
  lib,
  pkgs,
  inputs ? { },
  username,
  ...
}:

let
  mkOutOfStoreSymlink = path: config.lib.file.mkOutOfStoreSymlink path;

  # Dynamic paths based on platform and username
  homeDir = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";

  repoPath =
    if builtins.hasAttr "self" inputs && inputs.self ? sourceInfo then
      inputs.self.sourceInfo.outPath
    else if pkgs.stdenv.isDarwin then
      "${homeDir}/nix-darwin"
    else
      "${homeDir}/nix-darwin";

  dotfileDir = "${repoPath}/dotfiles";
in
{
  home.file = {
    ".config/ghostty".source = mkOutOfStoreSymlink "${dotfileDir}/ghostty";
    ".config/fish/config.fish".source = mkOutOfStoreSymlink "${dotfileDir}/fish/config.fish";
    ".config/starship".source = mkOutOfStoreSymlink "${dotfileDir}/starship";
  };
}
