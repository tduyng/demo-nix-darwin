{
  config,
  pkgs,
  inputs,
  username,
  ...
}:

{
  imports = [
    ./homebrew.nix
    ./system.nix
    ./packages.nix
  ];
  # DISABLE NIX MANAGEMENT since you're using Determinate installer
  nix.enable = false;

  system.primaryUser = username;
  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
    shell = pkgs.fish; # Set Fish as default shell
  };

  # Enable shells
  programs.zsh.enable = true;
  programs.fish.enable = true;

  # System configuration
  system = {
    stateVersion = 5;
    configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  };
}
