# Security configuration
{
  lib,
  pkgs,
  config,
  username,
  ...
}:
{
  options = {
    common.security-config.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = true;
    };
  };

  config = lib.mkIf config.common.security-config.enable {
    security = {
      sudo = {
        extraRules = [
          {
            users = [ "${username}" ];
            commands = [
              {
                command = "${pkgs.systemd}/bin/systemctl poweroff";
                options = [ "NOPASSWD" ];
              }
              {
                command = "${pkgs.systemd}bin/systemctl reboot";
                options = [ "NOPASSWD" ];
              }
              {
                command = "${pkgs.systemd}bin/systemctl kexec";
                options = [ "NOPASSWD" ];
              }
              {
                command = "/run/current-system/sw/bin/sudo modprobe cec";
                options = [ "NOPASSWD" ];
              }
              {
                command = "/run/current-system/sw/bin/sudo modprobe -r cec";
                options = [ "NOPASSWD" ];
              }
            ];
          }
        ];
      };
      pam = {
        services = {
          swaylock = {
            text = ''
              auth include login
            '';
          };
        };
      };
      rtkit.enable = true;

      polkit = {
        enable = true;
        extraConfig = ''
          polkit.addRule(function(action, subject) {
            if (
              subject.isInGroup("users")
                && (
                  action.id == "org.freedesktop.login1.reboot" ||
                  action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
                  action.id == "org.freedesktop.login1.power-off" ||
                  action.id == "org.freedesktop.login1.power-off-multiple-sessions"
                )
              )
            {
              return polkit.Result.YES;
            }
          })
        '';
      };
    };
  };
}
