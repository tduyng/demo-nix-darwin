{ config, pkgs, ... }:

{
  # System-wide packages (equivalent to environment.systemPackages in NixOS)
  environment.systemPackages = with pkgs; [
  ];
}
