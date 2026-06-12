{
  pkgs,
  lib,
  ...
}:
let
  dir = ./proton-versions;
  nixFiles = lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name) (
    builtins.readDir dir
  );

  protonPackages = lib.mapAttrs' (
    name: _: lib.nameValuePair (lib.removeSuffix ".nix" name) (dir + "/${name}")
  ) nixFiles;

  proton-ge-overlay =
    _self: super: lib.mapAttrs (_name: path: super.callPackage path { }) protonPackages;
in
{
  nixpkgs.overlays = [ proton-ge-overlay ];

  programs.steam.extraCompatPackages = map (name: pkgs.${name}) (lib.attrNames protonPackages);
}
