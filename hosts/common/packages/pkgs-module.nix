{ lib, ... }:
let
  dir = ./pkg-cats;
  nixFiles = lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name) (
    builtins.readDir dir
  );
in
{
  imports = [
    ./pkg-cats/package-overlays/proton-ge-overlays/proton-ge-overlay.nix
  ]
  ++ map (name: dir + "/${name}") (lib.attrNames nixFiles);
}
