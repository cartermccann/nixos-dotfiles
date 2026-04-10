{
  description = "BeepBeep & Surface — Multi-host NixOS Config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    google-workspace-cli = {
      url = "github:googleworkspace/cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, google-workspace-cli, zen-browser, ... }: {
    nixosConfigurations.BeepBeep = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit google-workspace-cli zen-browser; };
      modules = [
        ./hosts/beepbeep/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.carter = import ./home/common.nix;
            backupFileExtension = "backup";
          };
        }
      ];
    };

    nixosConfigurations.SurfaceDev = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit google-workspace-cli zen-browser; };
      modules = [
        ./hosts/surface/configuration.nix
        nixos-hardware.nixosModules.microsoft-surface-common
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.carter = import ./home/common.nix;
            backupFileExtension = "backup";
          };
        }
      ];
    };
  };
}
