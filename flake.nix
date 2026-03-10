{
  description = "BeepBeep & Surface — Multi-host NixOS Config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, ... }: {
    nixosConfigurations.BeepBeep = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
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
