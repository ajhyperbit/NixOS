{
  pkgs,
  nix-cachyos-kernel,
  ...
}:
{
  nixpkgs.overlays = [ nix-cachyos-kernel.overlays.pinned ]; # Force usage of binary cache if possible.

  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;

  # nix.settings.substituters = [ "https://cache.lantian.pub/lantian" ];
  # nix.settings.trusted-public-keys = [ "lantian:WVGO7vsRMSEN+h7Lp7kv6SAmrkEXgUGbbXm7jMDjBuQ=" ];
}
