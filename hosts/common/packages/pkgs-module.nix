{ lib, ... }:
let
  dir = ./pkg-cats;
  nixFiles = lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name) (
    builtins.readDir dir
  );
in
{
  imports = map (name: dir + "/${name}") (lib.attrNames nixFiles);
}
