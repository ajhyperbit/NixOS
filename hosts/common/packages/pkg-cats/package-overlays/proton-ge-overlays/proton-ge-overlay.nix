{
  lib,
  pkgs,
  config,
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
  options = {
    packages.proton-Packages.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = true;
      description = ''
        Proton-GE compatibility tool overlays. Adds custom Proton-GE
        builds from the `proton-versions` directory as a nixpkgs overlay
        and registers them as Steam extra compatibility packages.
      '';
    };
  };

  config = lib.mkIf config.packages.proton-Packages.enable {
    nixpkgs.overlays = [ proton-ge-overlay ];

    programs.steam.extraCompatPackages = map (name: pkgs.${name}) (lib.attrNames protonPackages);
  };
}
