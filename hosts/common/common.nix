# Main default config
{
  config,
  pkgs,
  host,
  username,
  options,
  lib,
  inputs,
  self,
  home,
  cursor_theme,
  cursor_size,
  ...
}:
let
  inherit (import ./variables.nix) keyboardLayout;
in
{
  imports = [
    ./users.nix
    ../../modules/local-hardware-clock.nix
    ./packages/packages.nix
  ];

  # BOOT related stuff
  boot = {
    #LINK - list of nix aliases https://github.com/NixOS/nixpkgs/blob/108230cebc6c328aa44f834d0aad647e26fcddc5/pkgs/top-level/aliases.nix
    #LINK - https://github.com/NixOS/nixpkgs/blob/108230cebc6c328aa44f834d0aad647e26fcddc5/pkgs/top-level/linux-kernels.nix
    #LINK - https://en.wikipedia.org/wiki/Linux_kernel_version_history
    #kernelPackages = lib.mkDefault pkgs.linuxPackages_latest; #Generic latest kernel

    #Zen Kernel
    #LINK - https://wiki.archlinux.org/index.php?title=Kernels&oldid=407966#Official_packages
    kernelPackages = lib.mkDefault pkgs.linuxPackages_zen; # Zen Kernel EOL: N/A

    #kernelPackages = lib.mkDefault pkgs.linuxPackages_6_12; # LTS Kernel 6.12 EOL: ???
    #kernelPackages = lib.mkDefault pkgs.linuxPackages_6_6; # LTS Kernel 6.6 EOL: 12/2026
    #kernelPackages = lib.mkDefault pkgs.linuxPackages_6_1; # SLTS Kernel 6.1 EOL: 8/2033

    #LINK - https://github.com/NixOS/nixpkgs/blob/108230cebc6c328aa44f834d0aad647e26fcddc5/pkgs/os-specific/linux/kernel/xanmod-kernels.nix
    #kernelPackages = lib.mkDefault pkgs.linuxPackages_xanmod; # Main xanmod Kernel EOL: ???
    #kernelPackages = lib.mkDefault pkgs.linuxPackages_xanmod_stable; # Stable 6.6 xanmod Kernel EOL: ???
    #kernelPackages = lib.mkDefault pkgs.linuxPackages_xanmod_latest; # Latest xanmod Kernel EOL: ???

    kernelParams = [
      "systemd.mask=systemd-vconsole-setup.service"
      "systemd.mask=dev-tpmrm0.device" # this is to mask that stupid 1.5 mins systemd bug
      "nowatchdog"
      #"modprobe.blacklist=sp5100_tco" #watchdog for AMD
      #"modprobe.blacklist=iTCO_wdt" #watchdog for Intel
      "nohibernate"
      #"mitigations=off"
    ];
    tmp.cleanOnBoot = lib.mkDefault true;
    #supportedFilesystems = ["ntfs"];
    loader = {
      systemd-boot.enable = lib.mkDefault true;
      efi.canTouchEfiVariables = lib.mkDefault true;
    };

    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usb_storage"
        "usbhid"
        "sd_mod"
      ];
      kernelModules = [ ];
    };

    # Make /tmp a tmpfs
    tmp = {
      useTmpfs = false;
      tmpfsSize = "30%";
    };

    # Appimage Support
    binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };

    plymouth.enable = false;

    crashDump.enable = true;
  };

  nix = {
    optimise = {
      automatic = true;
      dates = [ "06:00" ];
    };
    settings = {
      #warn-dirty = false;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      #auto-optimise-store = true;
      substituters = [
        "https://cache.nixos.org?priority=10"
        "https://hyprland.cachix.org"
        "https://nix-community.cachix.org"
        "https://nix-gaming.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 60d";
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;

      overlays = [
      ];
    };
  };

  environment.variables = {
    QML2_IMPORT_PATH = "${pkgs.qt6.qt5compat}/lib/qt-6/qml:${pkgs.qt6.qtbase}/lib/qt-6/qml";
  };

  environment.sessionVariables = rec {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";

    # Not officially in the specification
    XDG_BIN_HOME = "$HOME/.local/bin";
    PATH = [
      "${XDG_BIN_HOME}"
    ];

    XCURSOR_THEME = "${cursor_theme}";
    XCURSOR_SIZE = 32; # {cursor_size};
    HYPRCURSOR_SIZE = 32; # {cursor_size};
    HYPRCURSOR_THEME = "rose-pine-hyprcursor";

    QML_IMPORT_PATH = "${pkgs.hyprland-qt-support}/lib/qt-6/qml";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };

  environment = {
    shellInit = ''
      findlink () {
        origUser=$LOGNAME
        location=$(readlink -f "$(command -v $1)")

        if [ -n "$location" ] && [ "$location" != "/home/$origUser" ]; then
          printf "$location\n"
        fi
      }
    '';

    shellAliases = {
      ll = "ls -l";
      soft-reboot = "systemctl kexec";
      sr = "systemctl kexec";
      google-chrome = "google-chrome-stable";
      fl = "findlink";
    };
  };

  environment.defaultPackages = lib.mkForce [ ];

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

  networking = {
    networkmanager.enable = true;
    enableIPv6 = false;
    timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];
    #Allow VNC and Synergy through firewall
    firewall.allowedTCPPorts = [
      5900
      24800
    ];
    #firewall.allowedUDPPorts = [ ... ];
    firewall = {
      enable = true;
      trustedInterfaces = [ "tailscale0" ];
      # required to connect to Tailscale exit nodes
      checkReversePath = "loose";
    };
  };

  # Set your time zone.
  time.timeZone = "America/Chicago";

  #lib.mkMerge = {i18n.supportedLocales = ["all"];};

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  environment.plasma6.excludePackages = [
    #plasma-browser-integration
    #khelpcenter
    #spectacle
  ];

  #Services

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
        user = "ajhyperbit";
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
    #Printing
    #TODO: look into gutenprint and brlaser and/or pkgs.brgenml1lpr and pkgs.brgenml1cupswrapper for brother printers)
    #LINK: https://askubuntu.com/questions/1090410/16-04-how-do-i-install-canon-pixma-mg3620-driver
    #printing.enable = true;
    #avahi = {
    #  enable = true;
    #  nssmdns4 = true;
    #  openFirewall = true;
    #};

    #Hyprland
    hypridle.enable = true;

    greetd = {
      enable = true;
      useTextGreeter = true;
      settings = {
        default_session = {
          user = username;
          command = "${pkgs.tuigreet}/bin/tuigreet --time -w 120 --remember-session"; # start Hyprland with a TUI login manager
        };
      };
    };

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

    samba = {
      enable = true;
      openFirewall = true;
    };

    saned.enable = true;

    dbus.implementation = "broker";

    #Mouse configuration daemon
    ratbagd.enable = true;
  };

  users.users.ajhyperbit = {
    isNormalUser = true;
    description = "AJHyperBit";
    extraGroups = [
      "flatpak"
      "disk"
      "qemu"
      "kvm"
      "libvirtd"
      "sshd"
      "networkmanager"
      "wheel"
      "audio"
      "video"
      "root"
      "greeter"
      "gamemode"
      "seat"
      "vboxusers"
      "dialout"
      "docker"
      "ydotool"
    ];
  };

  #Programs

  programs = {
    #Hyprland
    hyprland = {
      enable = true;
      #package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland; #hyprland-git
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland; # xdphls
      xwayland.enable = true;
      withUWSM = true;
    };
    #waybar.enable = true; #has some kind of race condition when used in the Hyprland UWSM env
    hyprlock.enable = true;
    firefox.enable = true;
    git.enable = true;

    zsh = {
      enable = true;
      enableBashCompletion = true;
    };

    thunar.enable = true;
    thunar.plugins = with pkgs; [
      xfce4-exo
      xfce.mousepad
      xfce.thunar-archive-plugin
      xfce.thunar-volman
      xfce.thunar-media-tags-plugin
      xfce.tumbler
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
      #clean.enable = true;
      #clean.extraArgs = "--keep-since 4d --keep 3";
      #flake = "";
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
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      #dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
      extraPackages = with pkgs; [
        xorg.libXcursor
        xorg.libXi
        xorg.libXinerama
        xorg.libXScrnSaver
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
        "--mangoapp"
      ];
    };

    #Virtualization (Windows VM) #TODO: move to it's own module (unsure if laptop will ever do some kind of Windows VM stuff, might just RDP/Parsec/VNC into it.)
    #virt-manager.enable = true;

    #TODO: (Research) Something coding related (VS code talks about it)
    direnv.enable = true;
    direnv.nix-direnv.enable = true;

    nix-ld = {
      enable = true;
      #libraries = pkgs.steam-run.fhsenv.args.multiPkgs pkgs;
    };

    thunderbird = {
      enable = true;
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
  };

  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
      extraPkgs =
        pkgs: with pkgs; [
          gamescope
          mangohud
        ];
    };
  };

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
      };
      #https://www.reddit.com/r/NixOS/comments/177wcyi/comment/k4vok4n
    };
    spiceUSBRedirection.enable = true;

    # Enable common container config files in /etc/containers
    containers = {
      enable = true;
    };
    #Podman https://nixos.wiki/wiki/Podman
    podman = {
      enable = true;
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      # Make the Podman socket available in place of the Docker socket, so Docker tools can find the Podman socket.
      dockerSocket.enable = true;
      # Make the Podman and Docker compatibility API available over the network with TLS client certificate authentication.
      #networkSocket.enable = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
    virtualbox = {
      host = {
        enable = true;
        addNetworkInterface = true;
        enableExtensionPack = true;
      };
      #guest.enable = true;
    };
  };

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
  #qt = {
  #  enable = true;
  #  style = "breeze";
  #  platformTheme = "kde";
  #};

  security = {
    sudo = {
      extraRules = [
        {
          users = [ "${username}" ];
          commands = [
            {
              command = "/run/current-system/sw/bin/systemctl poweroff";
              options = [ "NOPASSWD" ];
            }
            {
              command = "/run/current-system/sw/bin/systemctl reboot";
              options = [ "NOPASSWD" ];
            }
            {
              command = "/run/current-system/sw/bin/systemctl kexec";
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

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  documentation.nixos.enable = false;

  #home-manager.useGlobalPkgs = true;
  #home-manager.useUserPackages = true;
  #home-manager.users.ajhyperbit = { imports = [ ./config/home.nix ];};
  #home-manager.extraSpecialArgs = {inherit inputs self username;};
  #home-manager.backupFileExtension = "hm-bak";

  systemd = {
    services.flatpak-repo = {
      path = [ pkgs.flatpak ];
      script = ''
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      '';
    };

    services.NetworkManager-wait-online.enable = pkgs.lib.mkForce false;

    #Sleep settings
    sleep.extraConfig = ''
      AllowSuspend=no
      AllowHibernation=no
      AllowHybridSleep=no
      AllowSuspendThenHibernate=no
    '';
  };

  # zram
  zramSwap = {
    enable = true;
    priority = 100;
    memoryPercent = 30;
    swapDevices = 1;
    algorithm = "zstd";
  };
}
