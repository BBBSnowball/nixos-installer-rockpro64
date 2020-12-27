# Create a nixos installer for the RockPro64

The RockPro64 currently is not yet fully upstreamed into uboot and the kernel and as such the generic nixos installer will not boot


## Building

There is no cross-compiling support in this repo currently so this must be built on a aarch64 machine (or possibly an emulated aarch64 qemu vm).
It has been tested on a c2.large.arm machine on packet.net.

Note: Currently you need to build on the nixos-unstable channel (20.03pre at the moment) as the image produced by stable 19.03 does not boot.

```
# To build, use:
# optional: ln -s ./user-config-snowball.nix user-config.nix
nix-build

# When it completes the image will be in the result symlink dir:
find result/ -iname "*.img"
# result/sd-image/nixos-sd-image-19.03pre-git-aarch64-linux.img


```

## Make a bootable sdcard


In the below commands replace mmcblkX with the correct sdcard device.

```
# Copy the image to the sdcard
zstd -d <./result/sd-image/nixos-sd-image-*.img.zst | sudo dd of=/dev/mmcblkX bs=100M status=progress && sync
```
