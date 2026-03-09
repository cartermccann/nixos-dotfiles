{ config, pkgs, ... }:

{
  home.username = "carter";
  home.homeDirectory = "/home/carter";

  programs.git = {
    enable = true;
    userName = "cartermccann";
    userEmail = "cjmccann00@gmail.com";
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
    fastfetch
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
