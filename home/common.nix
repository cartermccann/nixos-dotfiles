{ config, pkgs, ... }:

{
  imports = [
    ./shell.nix
    ./git.nix
    ./neovim.nix
    ./alacritty.nix
  ];

  home.username = "carter";
  home.homeDirectory = "/home/carter";

  home.packages = with pkgs; [
    fastfetch
  ];

  # Qtile config
  xdg.configFile."qtile/config.py".source = ./qtile/config.py;
  xdg.configFile."qtile/autostart.sh" = {
    source = ./qtile/autostart.sh;
    executable = true;
  };

  home.stateVersion = "25.11";
}
