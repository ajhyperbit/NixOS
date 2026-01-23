{
  config,
  pkgs,
  lib,
  ...
}:
{
  #Fix for https://github.com/NixOS/nixpkgs/issues/425323
  #nixpkgs.overlays = [
  #  (final: prev: {
  #    jdk8 = final.openjdk8-bootstrap;
  #  })
  #];
}
