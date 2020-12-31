{ config, lib, pkgs, systems, ... }:
let
  kernels = import ./kernels.nix { inherit pkgs; };
  defaultKernelVersion = "4.19";  # or 4.20 or 5.3
in
{
  boot = {
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
    kernelPackages = lib.mkDefault kernels.linuxPackages_rock64.${defaultKernelVersion};
    kernelParams = [ "console=ttyS2,115200n8" ];
  };

  #services.journald.console = "ttyS2";
}
