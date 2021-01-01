{ nixos ? import <nixpkgs/nixos>
, nixpkgsPath ? <nixpkgs>
, system ? builtins.currentSystem
, config1 ? ./sd-image-aarch64-rockpro64.nix
, config2 ? ./user-config.nix }:
let
  modules = [ config1 ] ++ (if builtins.pathExists config2 then [ config2 ] else []);
  evaluatedSystem = if builtins.functionArgs nixos ? modules
    then nixos { inherit modules system; }  # flake
    else nixos { configuration = { imports = modules; }; inherit system; };
in
evaluatedSystem.config.system.build.sdImageRockchip
