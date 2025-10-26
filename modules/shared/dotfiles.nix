{
  config,
  pkgs,
  inputs ? { },
  username,
  ...
}:

let
  mkOutOfStoreSymlink = path: config.lib.file.mkOutOfStoreSymlink path;
  homeDir = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";

  repoPath =
    if builtins.hasAttr "self" inputs && inputs.self ? sourceInfo then
      inputs.self.sourceInfo.outPath
    else
      "${homeDir}/nix-darwin";

  dotfileDir = "${repoPath}/dotfiles";
in
{
  home.file = {
    ".config/ghostty".source = mkOutOfStoreSymlink "${dotfileDir}/ghostty";
    ".config/fish/config.fish".source = mkOutOfStoreSymlink "${dotfileDir}/fish/config.fish";
    ".config/starship".source = mkOutOfStoreSymlink "${dotfileDir}/starship";
    ".zshrc".source = mkOutOfStoreSymlink "${dotfileDir}/zsh/.zshrc";
  };
}
