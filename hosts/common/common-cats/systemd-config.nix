# Systemd services and sleep configuration
{
  lib,
  pkgs,
  config,
  ...
}:
{
  options = {
    common.systemd-config.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = true;
      description = ''
        Systemd configuration, including a one-shot service to register
        the Flathub Flatpak remote, disabling NetworkManager-wait-online,
        and preventing suspend/hibernate via logind sleep settings.
      '';
    };
  };

  config = lib.mkIf config.common.systemd-config.enable {
    systemd = {
      services.flatpak-repo = {
        path = [ pkgs.flatpak ];
        script = ''
          flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        '';
      };

      services.NetworkManager-wait-online.enable = pkgs.lib.mkForce false;

      #Sleep settings
      sleep.settings.Sleep = {
        AllowSuspend = "no";
        AllowHibernation = "no";
        AllowHybridSleep = "no";
        AllowSuspendThenHibernate = "no";
      };
    };
  };
}
