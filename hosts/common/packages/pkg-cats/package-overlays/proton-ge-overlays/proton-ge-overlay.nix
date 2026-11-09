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

  localProtonPackages = lib.mapAttrs' (
    name: _: lib.nameValuePair (lib.removeSuffix ".nix" name) (dir + "/${name}")
  ) nixFiles;

  proton-ge-overlay =
    _self: super: lib.mapAttrs (_name: path: super.callPackage path { }) localProtonPackages;

  allProtonPackages = (map (name: pkgs.${name}) (lib.attrNames localProtonPackages)) ++ [
    pkgs.proton-ge-bin
  ];
in
{
  options = {
    packages.proton-Packages.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = true;
      description = ''
        Proton-GE compatibility tool overlays. Adds custom Proton-GE
        builds from the `proton-versions` directory and the nixpkgs Proton-GE
        as a nixpkgs overlay and registers them as Steam extra compatibility packages.
      '';
    };

    packages.proton-Packages.packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "Custom and the nixpkgs Proton-GE.";
    };
  };

  config = lib.mkIf config.packages.proton-Packages.enable {
    nixpkgs.overlays = [ proton-ge-overlay ];

    packages.proton-Packages.packages = allProtonPackages;

    programs.steam.extraCompatPackages = config.packages.proton-Packages.packages;
  };
}
