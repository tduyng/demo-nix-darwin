{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Editors
    neovim

    # CLI Utilities
    eza
    zoxide

    # Node.js Tools
    pnpm
    eslint
    prettier

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
