# Boot related config
{
  lib,
  pkgs,
  config,
  ...
}:
{
  options = {
    common.boot.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = true;
    };
  };

  config = lib.mkIf config.common.boot.enable {
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
        "threadirqs"
      ];

      kernelModules = [ "ntsync" ];

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
  };
}
