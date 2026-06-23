# Hardware configuration
{
  lib,
  config,
  ...
}:
{
  options = {
    common.hardware.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = true;
    };
  };

  config = lib.mkIf config.common.hardware.enable {
    hardware = {
      bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings = {
          General = {
            Enable = "Source,Sink,Media,Socket";
            #Experimental = true;
          };
        };
      };
      logitech.wireless = {
        enable = true;
        enableGraphical = true;
      };
      sane = {
        enable = true;
        #brscan5.enable = true;
        #dsseries.enable = true;
      };
    };
  };
}
