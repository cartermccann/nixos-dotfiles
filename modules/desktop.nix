{
  config,
  lib,
  pkgs,
  zen-browser,
  ...
}:

{
  # Display manager + Qtile (ly offers both X11 and Wayland sessions)
  services.displayManager.ly.enable = true;
  services.xserver = {
    enable = true;
    autoRepeatDelay = 200;
    autoRepeatInterval = 35;
    windowManager.qtile.enable = true;
    xkb.layout = "us";
  };

  services.libinput.enable = true;

  # Compositor (X11 only — Wayland handles compositing natively)
  services.picom = {
    enable = true;
    settings = {
      shadow = true;
      shadow-radius = 12;
      shadow-offset-x = -7;
      shadow-offset-y = -7;
      shadow-opacity = 0.6;
      fading = true;
      fade-in-step = 0.03;
      fade-out-step = 0.03;
      inactive-opacity = 0.9;
      frame-opacity = 0.9;
      corner-radius = 8;
      backend = "xrender";
      vsync = true;
    };
  };

  # Desktop packages
  environment.systemPackages = with pkgs; [
    alacritty
    rofi # supports both X11 and Wayland
    dunst
    networkmanagerapplet
    pavucontrol

    # X11
    feh
    flameshot
    xclip

    #apps
    spotify
    zen-browser.packages.x86_64-linux.default

    # Wayland
    grim # screenshot
    slurp # region selection
    wl-clipboard # clipboard
  ];
}
