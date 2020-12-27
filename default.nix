{ nixos ? import <nixpkgs/nixos>
, system ? builtins.currentSystem
, config1 ? ./sd-image-aarch64-rockpro64.nix
, config2 ? ./user-config.nix }:
let
  evaluatedSystem = nixos { configuration = { imports = [ config1 ] ++ (if builtins.pathExists config2 then [ config2 ] else []); }; };
  sdImage1 = evaluatedSystem.config.system.build.sdImage;
in
sdImage1
