{ pkgs }:
let
  versions = [ "4.19" "4.20" "5.3" ];
  forAllVersions = pkgs.lib.genAttrs versions;
in rec {
  linux_rock64 = forAllVersions (version: pkgs.callPackage (./linux-rock64 + "/${version}.nix") {
    kernelPatches = [ pkgs.kernelPatches.bridge_stp_helper ];
  });

  linuxPackages_rock64 = forAllVersions (version: pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor linux_rock64.${version}));
}
