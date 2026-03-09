{ config, pkgs, ... }:

{
  home.username = "carter";
  home.homeDirectory = "/home/carter";

  programs.git = {
    enable = true;
    userName = "Carter";
    userEmail = "your@email.com";
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
  };

  home.packages = with pkgs; [
    ripgrep
    fd
    fzf
    tree
    neofetch
    nodejs
    python3
  ];

  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -la";
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#BeepBeep";
      update = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#BeepBeep --upgrade";
    };
  };

  home.stateVersion = "25.11";
}
