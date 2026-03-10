{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common.nix
    ../../modules/desktop.nix
    ../../modules/dev.nix
  ];

  networking.hostName = "SurfaceDev";

  # nixos-hardware microsoft-surface-common is imported in flake.nix
  # It provides: linux-surface kernel patches, IPTSD touchscreen, surface-control

  system.stateVersion = "25.11";
}
