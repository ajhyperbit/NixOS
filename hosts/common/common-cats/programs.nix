# Programs
{
  lib,
  pkgs,
  config,
  username,
  ...
}:
let
  nhArgs = "--keep-since 7d --keep 5 --optimise";
in
{
  options = {
    common.programs.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = true;
    };
  };

  config = lib.mkIf config.common.programs.enable {
    programs = {
      firefox.enable = lib.mkDefault true;

      git = {
        enable = true;
        lfs = {
          enable = true;
          enablePureSSHTransfer = true;
        };
      };

      ssh.startAgent = true;

      zsh = {
        enable = true;
        enableBashCompletion = true;
      };

      thunar.enable = true;
      thunar.plugins = with pkgs; [
        xfce4-exo
        mousepad
        thunar-archive-plugin
        thunar-volman
        thunar-media-tags-plugin
        tumbler
        ffmpegthumbnailer
        webp-pixbuf-loader
        poppler
        libgsf
        totem
        gnome-epub-thumbnailer
        mcomix
        f3d
      ];

      nh = {
        enable = true;
        clean = {
          enable = true;
          extraArgs = nhArgs;
          dates = "monthly";
        };
        flake = "/home/${username}/NixOS-Hyprland";
      };

      #KDE window borders fix
      dconf = {
        enable = true;
        #profiles.user.databases = [
        #  {
        #    settings."org/gnome/desktop/interface" = {
        #      gtk-theme = "Breeze-Dark";
        #      icon-theme = "breeze-dark";
        #      font-name = "Noto Sans, 10";
        #      document-font-name = "Noto Sans, 10";
        #      monospace-font-name = "Noto Sans Mono, 10";
        #    };
        #  }
        #];
      };
      #fuse.userAllowOther = true;
      mtr.enable = true;

      steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        #dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
        extraPackages = with pkgs; [
          libXcursor
          libXi
          libXinerama
          libXScrnSaver
          libpng
          libpulseaudio
          libvorbis
          stdenv.cc.cc.lib
          libkrb5
          keyutils
        ];
        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
        #gamescopeSession.enable = true;
      };
      gamescope = {
        enable = true;
        capSysNice = false;
        args = [
          "--rt"
          "--expose-wayland"
        ];
      };

      direnv.enable = true;
      direnv.nix-direnv.enable = true;

      nix-ld = {
        enable = true;
      };

      thunderbird = {
        enable = false;
        preferencesStatus = "user";
      };

      gamemode = {
        enable = true;
        enableRenice = true;

        settings = {
          general = {
            renice = 10;
          };
          custom = {
            start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
            end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
          };
        };
      };
      usbtop.enable = true;
      tmux = {
        enable = false;
        extraConfig = ''
          set -g update-environment "GPG_TTY SSH_TTY"
          set-hook -g client-attached 'run-shell "gpg-connect-agent updatestartuptty /bye"'
        '';
      };
    };
  };
}
