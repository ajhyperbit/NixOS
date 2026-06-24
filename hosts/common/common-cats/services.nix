# Services
{
  lib,
  pkgs,
  config,
  username,
  ...
}:
{
  options = {
    common.services.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = true;
    };
  };

  config = lib.mkIf config.common.services.enable {
    services = {
      desktopManager.plasma6.enable = true;
      # Enable the OpenSSH daemon.
      openssh = {
        enable = true;
        settings.X11Forwarding = false;
      };

      pulseaudio = {
        enable = false;
        package = pkgs.pulseaudioFull;
      };

      flatpak.enable = true;

      dbus.enable = true;

      tailscale = {
        enable = true;
        openFirewall = true;
        extraSetFlags = [
          "--advertise-exit-node"
        ];
        useRoutingFeatures = "both";
      };

      envfs.enable = true;

      fstrim = {
        enable = true;
        interval = "weekly";
      };

      displayManager = {
        sddm = {
          enable = false;
          #wayland.enable = true;
          #theme = "catppuccin-mocha";
        };
        autoLogin = {
          enable = false;
          user = "${username}";
        };
      };

      xserver = {
        enable = false;
      };

      #Auto CPU Freq
      #auto-cpufreq.enable = true;
      # Fwupd # Firmware updater
      #fwupd = {
      #  enable = true;
      #};

      greetd = {
        enable = true;
        useTextGreeter = true;
        # package = pkgs.tuigreet;
      };

      #sysc-greet = {
      #enable = true;
      #compositor = "hyprland"; # or "hyprland" or "sway"
      # Optional: Set initial session for auto-login
      #settings.initial_session = {
      #  command = "${pkgs.uwsm}/bin/uwsm start -F -- ${pkgs.hyprland}/bin/Hyprland";
      #  user = "${username}";
      #};
      #};

      smartd = {
        enable = false;
        autodetect = true;
      };

      gvfs.enable = true;
      tumbler.enable = true;

      udev.enable = true;

      libinput.enable = true;

      rpcbind.enable = false;
      nfs.server.enable = false;

      upower.enable = true;

      mysql = {
        enable = true;
        package = pkgs.mariadb;
      };

      #onedrive.enable = true;

      #btrfs.autoScrub = {
      #  enable = true;
      #  interval = "weekly";
      #  fileSystems = ["/"];
      #};

      saned.enable = true;

      dbus.implementation = "broker";

      #Mouse configuration daemon
      ratbagd.enable = true;
    };
  };
}
