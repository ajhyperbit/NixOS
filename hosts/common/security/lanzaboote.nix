#borrowed from https://github.com/fufexan/dotfiles/tree/2947f27791e97ea33c48af4ee2d0188fe03f80dd
{
  pkgs,
  lib,
  inputs,
  ...
}:
# lanzaboote config
{
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  boot = {
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    # we let lanzaboote install systemd-boot
    loader.systemd-boot.enable = lib.mkForce false;
  };

  environment.systemPackages = [ pkgs.sbctl ];
}
