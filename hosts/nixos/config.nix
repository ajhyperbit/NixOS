# Main default config
{
  config,
  pkgs,
  host,
  username,
  options,
  lib,
  inputs,
  system,
  stateVersion-host,
  ...
}:
{
  imports = [
  ];

  # BOOT related stuff
  boot = {
    #kernelPackages = pkgs.linuxPackages_latest; # Kernel

    kernelParams = [
      "amd_iommu=on"
    ];

    kernelModules = [
      "vfio_virqfd"
      "vfio_pci"
      "vfio_iommu_type1"
      "vfio"
      #From https://github.com/NixOS/nixos-hardware/blob/master/asus/rog-strix/x570e/default.nix
      "btintel" # Bluetooth driver for Intel AX200 802.11ax
      "nct6775" # Temperature and Fan Sensor for Nuvoton NCT6798D-R
    ];

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
  };

  networking = {
    hostName = "${host}";
    interfaces.enp6s0.wakeOnLan.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [
        47984
        47989
        47990
        48010
      ];
      allowedUDPPortRanges = [
        {
          from = 47998;
          to = 48000;
        }
        {
          from = 8000;
          to = 8010;
        }
      ];
    };
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    #amdgpu.amdvlk = {
    #  enable = true;
    #  support32Bit.enable = true;
    #};
  };

  environment.systemPackages = with pkgs; [
    ddclient
    btop-rocm
    #davinci-resolve-studio
  ];

  lib.mkMerge = {
    users.users.ajhyperbit = {
      extraGroups = [
        "ddclient"
      ];
    };
  };

  #ANCHOR - Services

  services = {
    #DDNS config
    ddclient = {
      enable = true;
      interval = "10min";
      configFile = "/etc/ddclient/ddclient.conf";
    };

    sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };

    samba = {
      enable = true;
      openFirewall = true;
      settings = {
        global = {
          "workgroup" = "WORKGROUP";
          "server string" = "AJ-NixOS-PC";
          "netbios name" = "AJ-NixOS-PC";
          "invalid users" = [
            "root"
          ];
          "passwd program" = "/run/wrappers/bin/passwd %u";
          security = "user";

          "min protocol" = "SMB3";
          "aio read size" = 1048576;
          "aio write size" = 1048576;
          "strict locking" = "no";
          "use sendfile" = "yes";
          "oplocks" = "no";
          "level2 oplocks" = "no";
          "mangled names" = "no";
        };

        ajhyperbit = {
          "valid users" = "ajhyperbit";
          path = "/home/ajhyperbit";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "ajhyperbit";
          "force group" = "users";
        };

        media = {
          "valid users" = "ajhyperbit";
          path = "/run/media/ajhyperbit";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "ajhyperbit";
          "force group" = "users";
          "acl allow execute always" = "yes";
        };
      };
    };

    samba-wsdd = {
      enable = true;
      openFirewall = true;
    };
  };

  environment = {
    #shellAliases = {
    #  google-chrome = "google-chrome-stable"
    #};
    variables = {
      #QT_STYLE_OVERRIDE = "breeze";
      #QT_QPA_PLATFORMTHEME= "qt5ct";
    };

    sessionVariables = {
      #no_hardware_cursors = "true";
      #WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
      #KDE_FULL_SESSION = "true";
      #QT_QPA_PLATFORM = "wayland;xcb";
      #QT_QPA_PLATFORMTHEME= "qt5ct";
      #GDK_BACKEND = "wayland,x11,*";
    };
  };

  #XDG Portals
  xdg = {
    #autostart.enable = true;
    portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = with pkgs; [
        #xdg-desktop-portal
        #xdg-desktop-portal-kde
        xdg-desktop-portal-gtk
        #xdg-desktop-portal-hyprland
      ];
      xdgOpenUsePortal = true;
      configPackages = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal
      ];

      config = {
        #  common = {
        #    default = [
        #      "kde"
        #      ];
        #  };
        #"org.freedesktop.impl.portal.FileChooser"= [
        #  "kde"
        #    ];
      };
    };
  };

  # Microcode
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = stateVersion-host; # Did you read the comment?
}
