# XDG portal and Qt configuration
{
  lib,
  config,
  ...
}:
{
  options = {
    common.xdg-qt.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = true;
    };
  };

  config = lib.mkIf config.common.xdg-qt.enable {
    services.spice-vdagentd.enable = true;

    xdg = {
      portal = {
        enable = true;
        extraPortals = [
          #xdg-desktop-portal-gtk
          #xdg-desktop-portal-kde
        ];
        xdgOpenUsePortal = true;
      };
    };
    qt = {
      enable = true;
      #style = "breeze";
    };
  };
}
