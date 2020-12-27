{ nixos ? import <nixpkgs/nixos>
, system ? builtins.currentSystem
, config1 ? ./sd-image-aarch64-rockpro64.nix
, config2 ? ./user-config.nix }:
let
  evaluatedSystem = nixos { configuration = { imports = [ config1 ] ++ (if builtins.pathExists config2 then [ config2 ] else []); }; };
  sdImage1 = evaluatedSystem.config.system.build.sdImage;
  inherit (evaluatedSystem) pkgs;
  sdImage2 = pkgs.stdenv.mkDerivation {
    name = "nixos-install-aarch64-rockpro64-with-uboot";
    version = "0.1";
    src = sdImage1;
    buildInputs = [ pkgs.ubootRockPro64 ];
    nativeBuildInputs = with pkgs; [ utillinux zstd ];
    unpackPhase = ''
      zstd -d <$src/sd-image/nixos-sd-image-*.img.zst >image
    '';
    buildPhase = ''
      (echo d; echo 1; echo p; echo w) | fdisk ./image
      dd if=${pkgs.ubootRockPro64}/idbloader.img of=image conv=fsync,notrunc bs=512 seek=64
      dd if=${pkgs.ubootRockPro64}/u-boot.itb    of=image conv=fsync,notrunc bs=512 seek=16384
    '';
    installPhase = ''
      mkdir $out $out/sd-image
      cp $src/nix-support -r $out/
      filename=$(cd $src/sd-image && ls -1 nixos-sd-image-*.img.zst)
      zstd <image >$out/sd-image/"$filename"
    '';
  };
in
sdImage2
