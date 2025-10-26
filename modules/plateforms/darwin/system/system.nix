{ config, pkgs, ... }:

{
  # macOS system defaults
  system.defaults = {
    # dock = {
    #   autohide = true;
    #   mru-spaces = false;
    #   orientation = "bottom";
    #   showhidden = true;
    # };
    #
    # finder = {
    #   AppleShowAllExtensions = true;
    #   FXPreferredViewStyle = "clmv";
    #   ShowPathbar = true;
    #   ShowStatusBar = true;
    # };
    #
    # NSGlobalDomain = {
    #   AppleShowAllExtensions = true;
    #   InitialKeyRepeat = 14;
    #   KeyRepeat = 1;
    #   NSAutomaticCapitalizationEnabled = false;
    #   NSAutomaticDashSubstitutionEnabled = false;
    #   NSAutomaticPeriodSubstitutionEnabled = false;
    #   NSAutomaticQuoteSubstitutionEnabled = false;
    #   NSAutomaticSpellingCorrectionEnabled = false;
    #   NSNavPanelExpandedStateForSaveMode = true;
    #   NSNavPanelExpandedStateForSaveMode2 = true;
    # };
    #
    # loginwindow.GuestEnabled = false;
    # screencapture.location = "~/Pictures/Screenshots";
  };
}
