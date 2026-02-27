{
  inputs,
  config,
  pkgs,
  system,
  ...
}:
{
  nixpkgs.overlays = [
    # inputs.umu.overlays.default
    inputs.lumen.overlays.default
  ];
  environment.systemPackages = [
    # (inputs.umu.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
    #   withTruststore = true;
    #   withDeltaUpdates = true;
    # })
    pkgs.lumen
  ];
}
