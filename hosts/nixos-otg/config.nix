# Main default config
{
  config,
  pkgs,
  otg-host,
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
  # BOOT related stuff
  boot = {
    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usbhid"
        "usb_storage"
        "uas"
        "sd_mod"
        "sr_mod"
      ];
      kernelModules = [ ];
    };
    extraModulePackages = [ ];

    loader = {
      systemd-boot.enable = false;
      grub = {
        enable = true;
        efiSupport = true;
        efiInstallAsRemovable = true;
      };
      efiInstallAsRemovable = true;
      efi.canTouchEfiVariables = lib.mkForce false;
      efi.efiSysMountPoint = "/boot";
    };
  };

  networking = {
    useDHCP = lib.mkDefault true;
    hostName = "${otg-host}";
    firewall = {
      enable = true;
    };
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  environment.systemPackages = with pkgs; [
    btop
  ];

  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
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

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
