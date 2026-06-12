{
  lib,
  pkgs,
  config,
  ...
}:
{
  options = {
    packages.ardunio.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };

  config = lib.mkIf config.packages.ardunio.enable {
    environment.systemPackages = with pkgs; [
      arduino
      arduino-core
      arduino-cli
      #arduino-mk
      #arduino-ide
    ];
  };
}
