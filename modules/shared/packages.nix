{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # CLI Utilities
    eza
    zoxide

    # Node.js Tools
    pnpm
    nodePackages.eslint
    nodePackages.prettier

    # Shell & Prompt
    fish
    starship

    # Other Utilities
    fnm

    # Fonts
    fira-code
    nerd-fonts.symbols-only
  ];
}
