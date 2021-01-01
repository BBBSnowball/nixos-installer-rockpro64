{ config, lib, pkgs, systems, ... }:
let
  baudRate = 1500000;  # 1.5 MBaud, also used by boot ROM and u-boot
in
{
  boot = {
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    kernelParams = [ "console=ttyS2,${toString baudRate}n8" ];
  };

  #services.journald.console = "ttyS2";

  # This adds 1.5 MBaud for all ttys.
  services.mingetty.serialSpeed = lib.mkOptionDefault (lib.mkBefore [ baudRate ]);

  # I would like to set 1.5 MBaud for ttyS2 only. However, we would have to use an overrides.conf
  # to not override all option of serial-getty@.service. NixOS will use an override.conf if a
  # service with the same name already exists but this is not the case here because the upstream
  # service has a different name (no instance suffix). We cannot use environment.etc either because
  # the relevant directory points to a read-only store path.
  #systemd.services."serial-getty@ttyS2".serviceConfig.ExecStart = [ "" "TODO" ];
  #environment.etc."systemd/system/serial-getty@ttyS2.service.d/overrides.conf".text = ''
  #  [Service]
  #  ExecStart=
  #  ExecStart=TODO
  #'';
}
