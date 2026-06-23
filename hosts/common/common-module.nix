{ lib, ... }:
let
  dir = ./common-cats;
  nixFiles = lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name) (
    builtins.readDir dir
  );
in
{
  imports = [
    ./hyprland/hyprland.nix
    ../../modules/local-hardware-clock.nix
  ]
  ++ map (name: dir + "/${name}") (lib.attrNames nixFiles);
}
