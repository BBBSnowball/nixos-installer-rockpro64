{ config, lib, pkgs, systems, ... }:
let
  linux_rock64_4_19 = pkgs.callPackage ./linux-rock64/4.19.nix {
    kernelPatches = [ pkgs.kernelPatches.bridge_stp_helper ];
  };
  linux_rock64_4_20 = pkgs.callPackage ./linux-rock64/4.20.nix {
    kernelPatches = [ pkgs.kernelPatches.bridge_stp_helper ];
  };
  linux_rock64_5_3 = pkgs.callPackage ./linux-rock64/5.3.nix {
    kernelPatches = [ pkgs.kernelPatches.bridge_stp_helper ];
  };

  linuxPackages_rock64_4_19 = pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor linux_rock64_4_19);
  linuxPackages_rock64_4_20 = pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor linux_rock64_4_20);
  linuxPackages_rock64_5_3 = pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor linux_rock64_5_3);

in
{
  boot = {
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
    # kernelPackages = linuxPackages_rock64_5_3;
    # kernelPackages = linuxPackages_rock64_4_20;
    kernelPackages = linuxPackages_rock64_4_19;
    kernelParams = [ "console=ttyS2,115200n8" ]
  };
}
