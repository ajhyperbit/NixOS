{ pkgs, ... }:
let
  proton-ge-overlay = _self: super: {
    proton-ge-9-27 = super.callPackage ./proton-ge-package-9-27.nix { };
    proton-ge-10-1 = super.callPackage ./proton-ge-package-10-1.nix { };
  };
in
{
  nixpkgs.overlays = [
    proton-ge-overlay
  ];

  programs.steam.extraCompatPackages = with pkgs; [
    proton-ge-9-27
    proton-ge-10-1
  ];
}
