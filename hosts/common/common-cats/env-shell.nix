# Shell init, aliases, and default packages
{
  lib,
  config,
  username,
  ...
}:
let
  nhArgs = "--keep-since 7d --keep 5 --optimise";

  inherit (import ../variables.nix) browser terminal;
in
{
  options = {
    common.env-shell.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = true;
    };
  };

  config = lib.mkIf config.common.env-shell.enable {
    environment = {

      shellInit = ''
        BROWSER=${browser}
        TERMINAL=${terminal}

        findlink () {
          origUser=$LOGNAME
          location=$(readlink -f "$(command -v $1)")

          if [ -n "$location" ] && [ "$location" != "/home/$origUser" ]; then
            printf "%s\n" "$location"
          fi
        }

        bottles-offline () {
          steam-run unshare --net --user --map-root-user -- bottles
        }

        # Only set GPG_TTY for SSH sessions
        if [[ -n "$SSH_TTY" ]]; then
          export GPG_TTY=$(tty)
        fi
      '';

      shellAliases = {
        ll = "ls -l";
        soft-reboot = "systemctl kexec";
        sr = "systemctl kexec";
        google-chrome = "google-chrome-stable";
        fl = "findlink";
        rebuild = "/home/${username}/NixOS-Hyprland/rebuild-flake.sh";
        tag = "/home/${username}/NixOS-Hyprland/tag.sh";
        clean = "nh clean all ${nhArgs}";
        llsblk = "lsblk -o NAME,FSTYPE,KNAME,SIZE,TYPE,MOUNTPOINT,SERIAL,UUID";
      };
    };

    environment.defaultPackages = lib.mkForce [ ];
  };
}
