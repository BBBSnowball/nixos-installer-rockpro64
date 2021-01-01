{ lib, writeText, utillinux, stdenv, python3, zstd }:

{ config }:
let
  system = lib.evalModules {
    modules = [
      { imports = [ ./options.nix ]; }
      config
    ];
  };
  manifest = writeText "manifest.json" (builtins.toJSON system.config);
in stdenv.mkDerivation {
  name = "image";
  dontUnpack = true;
  dontInstall = true;
  # Performance
  dontPatchELF = true;
  dontStrip = true;
  noAuditTmpdir = true;
  dontPatchShebangs = true;

  nativeBuildInputs = [
    python3 utillinux zstd
  ];
  buildPhase = if ! builtins.isNull system.config.compressResult then ''
    runHook preBuild
    echo ${./build-image.py} ${manifest} image
    python3 ${./build-image.py} ${manifest} image
    echo ${system.config.compressResult} image \>$out
    ${system.config.compressResult} image >$out
    runHook postBuild
  '' else ''
    runHook preBuild
    echo ${./build-image.py} ${manifest} $out
    python3 ${./build-image.py} ${manifest} $out
    runHook postBuild
  '';
}
