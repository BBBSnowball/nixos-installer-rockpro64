nixpkgsPath:
{ ... }:
{
  imports = [
    (nixpkgsPath + /nixos/modules/installer/cd-dvd/sd-image-aarch64.nix)
    ./rockpro64.nix
  ];
}
