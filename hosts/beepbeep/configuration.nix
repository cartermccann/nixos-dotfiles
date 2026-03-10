{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common.nix
    ../../modules/desktop.nix
    ../../modules/dev.nix
  ];

  networking.hostName = "BeepBeep";

  # Broadcom BCM4331 WiFi
  hardware.firmware = [ pkgs.linux-firmware ];
  boot.kernelModules = [ "wl" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
  boot.blacklistedKernelModules = [ "b43" "bcma" ];
  nixpkgs.config.permittedInsecurePackages = [
    "broadcom-sta-6.30.223.271-59-6.12.75"
  ];

  # Starlink WiFi auto-connect
  networking.networkmanager.ensureProfiles.profiles.starlink = {
    connection = {
      id = "STARLINK";
      type = "wifi";
      autoconnect = true;
    };
    wifi = {
      ssid = "STARLINK";
      mode = "infrastructure";
    };
    wifi-security = {
      key-mgmt = "wpa-psk";
      psk = "CHANGE_ME"; # Set your actual WiFi password before rebuilding
    };
  };

  system.stateVersion = "25.11";
}
