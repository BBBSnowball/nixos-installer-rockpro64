{
  description = "Configuration for RockPro64";

  outputs = { self, nixpkgs }: let
    nixpkgsPath = nixpkgs.outPath;
  in {
    nixosModule = self.nixosModules.rockpro64;
    nixosModules.rockpro64 = ./rockpro64.nix;

    packages.aarch64-linux = {
      rockpro64InstallImage = import ./default.nix { nixos = nixpkgs.lib.nixosSystem; inherit nixpkgsPath; system = "aarch64-linux"; };
      #rockpro64InstallImage = import ./default.nix { nixos = import "${nixpkgsPath}/nixos"; inherit nixpkgsPath; system = "aarch64-linux"; };
    };
    defaultPackage.aarch64-linux = self.packages.aarch64-linux.rockpro64InstallImage;
  };
}
