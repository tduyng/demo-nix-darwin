{ config, pkgs, ... }:

{
  programs = {
    # Home Manager self-management
    home-manager.enable = true;

    # Zoxide for smart cd
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
    };

    # Starship prompt
    starship.enable = true;
  };
}
