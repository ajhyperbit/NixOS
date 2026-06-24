{
  lib,
  pkgs,
  config,
  ...
}:
{
  options = {
    common.printing.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = true;
    };
  };

  config = lib.mkIf config.common.printing.enable {
    services = {
      #Printing
      #LINK: https://askubuntu.com/questions/1090410/16-04-how-do-i-install-canon-pixma-mg3620-driver

      printing = {
        enable = true;
        drivers = [
          pkgs.gutenprint
          pkgs.gutenprintBin
        ];
      };

      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
    };
  };
}
