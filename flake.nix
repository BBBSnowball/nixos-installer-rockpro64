{
  description = "Configuration for RockPro64";

  inputs.nixpkgs-nonflake.follows = "nixpkgs";
  inputs.nixpkgs-nonflake.flake = false;

  outputs = { self, nixpkgs, nixpkgs-nonflake }: {
    nixosModule = self.nixosModules.rockpro64;
    nixosModules.rockpro64 = import ./rockpro64.nix;

    packages.aarch64-linux = {
      #rockpro64InstallImage = import ./default.nix { nixos = nixpkgs.lib.nixosSystem; nixpkgsPath = nixpkgs-nonflake; system = "aarch64-linux"; };
      rockpro64InstallImage = import ./default.nix { nixos = import (nixpkgs-nonflake + /nixos); nixpkgsPath = nixpkgs-nonflake; system = "aarch64-linux"; };
    };
    defaultPackage.aarch64-linux = self.packages.aarch64-linux.rockpro64InstallImage;
  };
}
