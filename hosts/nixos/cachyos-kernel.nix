{
  pkgs,
  nix-cachyos-kernel,
  ...
}:
{
  nixpkgs.overlays = [ nix-cachyos-kernel.overlays.pinned ]; # Force usage of binary cache if possible.

  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;

  nix.settings.substituters = [ "https://attic.xuyh0120.win/lantian" ];
  nix.settings.trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];

}
