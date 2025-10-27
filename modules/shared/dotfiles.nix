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
  homeDir = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";
  repoPath = "${homeDir}/nix-darwin";
  dotfileDir = "${repoPath}/dotfiles";
in
{
  home.file = {
    ".config/ghostty".source = mkOutOfStoreSymlink "${dotfileDir}/ghostty";
    ".config/fish/config.fish".source = mkOutOfStoreSymlink "${dotfileDir}/fish/config.fish";
    ".config/starship".source = mkOutOfStoreSymlink "${dotfileDir}/starship";
  };
}
