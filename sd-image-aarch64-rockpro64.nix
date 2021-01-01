{ config, pkgs, lib, modulesPath, ... }:

with lib;

let
  # copied from sd-image.nix
  rootfsImage = pkgs.callPackage "${modulesPath}/../lib/make-ext4-fs.nix" ({
    inherit (config.sdImage) storePaths;
    compressImage = true;
    populateImageCommands = config.sdImage.populateRootCommands;
    volumeLabel = "NIXOS_SD";
  } // optionalAttrs (config.sdImage.rootPartitionUUID != null) {
    uuid = config.sdImage.rootPartitionUUID;
  });

  uboot = config.sdImage.ubootPackage;
  buildImage = pkgs.callPackage ./mic92-nixos-aarch64-images/pkgs/build-image { };
  sdImageRockchip = pkgs.callPackage ./mic92-nixos-aarch64-images/images/rockchip.nix {
    inherit uboot buildImage;
    aarch64Image = rootfsImage;
    # our image is doesn't contain a partition table
    extraConfig.partitions.nixos.useBootPartition = lib.mkForce false;
    extraConfig.partitions.nixos.sourceCompressed = true;
    extraConfig.compressResult = "${pkgs.zstd}/bin/zstd --stdout";
  };
in
{
  imports = [
    # most of the settings in sd-image-aarch64.nix are not so useful for Rockchip
    #"${modulesPath}/installer/cd-dvd/sd-image-aarch64.nix"

    # copied from sd-image-aarch64.nix
    "${modulesPath}/profiles/base.nix"
    "${modulesPath}/profiles/installation-device.nix"
    "${modulesPath}/installer/cd-dvd/sd-image.nix"

    # our settings for RockPro64 - used for installer and normal system
    ./rockpro64.nix
  ];

  options.sdImage.ubootPackage = with lib; mkOption {
    type = types.package;
    default = pkgs.ubootRockPro64;
    description = "u-boot package for the board, e.g. pkgs.ubootRock64, pkgs.ubootROCPCRK3399, pkgs.ubootPinebookPro";
  };

  # copied from sd-image-aarch64.nix
  config.sdImage.populateRootCommands = ''
    mkdir -p ./files/boot
    ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./files/boot
  '';

  config.system.build = {
    inherit rootfsImage uboot buildImage sdImageRockchip;
  };
}
