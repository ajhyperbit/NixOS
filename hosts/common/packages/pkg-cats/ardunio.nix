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
      description = ''
        Arduino development packages, including the IDE, core library,
        and command-line tools.
      '';
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
