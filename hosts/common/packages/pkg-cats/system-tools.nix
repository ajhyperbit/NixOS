{
  lib,
  pkgs,
  config,
  ...
}:
{
  options = {
    packages.system-tools.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = true;
    };
  };

  config = lib.mkIf config.packages.system-tools.enable {
    environment = {
      systemPackages = with pkgs; [
        # ── System Info, Hardware & Monitoring ────────────────────────────────────
        htop # Interactive process viewer
        netdata # Real-time system and application performance monitoring
        fastfetch # Fast system info fetcher (neofetch alternative)
        ghfetch # GitHub-style system info fetch
        screenfetch # Classic system info fetch for screenshots
        cpufetch # CPU-focused system info fetcher
        ramfetch # RAM-focused system info fetcher
        disfetch # Discord-style system info fetcher
        fetchutils # Collection of fetch utilities
        dmidecode # Read hardware info from BIOS/UEFI (SMBIOS/DMI)
        hwinfo # Detailed hardware configuration and probe tool
        pciutils # PCI bus utilities (lspci, setpci)
        usbutils # USB utilities (lsusb)
        i2c-tools # I2C bus probing and access utilities
        lm_sensors # Read hardware sensors (CPU temp, fan speeds, voltages)
        lshw # Detailed hardware configuration lister
        mesa-demos # Mesa OpenGL demo and benchmark programs
        furmark # GPU stress test and OpenGL/Vulkan benchmark
        phoronix-test-suite # Comprehensive cross-platform hardware benchmarking suite
        desktop-file-utils # Command line utilities for working with .desktop files

        # ── Disk & Storage ────────────────────────────────────────────────────────
        btrfs-progs # Btrfs filesystem utilities (balance, scrub, snapshot, etc.)
        parted # Command-line disk partition manipulation
        gparted # GTK GUI disk partition editor
        gsmartcontrol # GUI for SMART disk health data inspection
        qdirstat # Qt-based disk usage analyzer (like WinDirStat)
        ntfs3g # FUSE-based NTFS driver with full read/write support
        ddrescue # Data recovery tool for damaged or failing drives
        testdisk # Partition and file recovery utility
        disko # Declarative disk partitioning and formatting using nix
        gomtree # File system tree validation against recorded manifests

        # ── Networking & Remote Access ────────────────────────────────────────────
        tailscale # WireGuard-based mesh VPN
        filezilla # Cross-platform FTP, FTPS, and SFTP client
        putty # SSH and serial terminal emulator
        remmina # Remote desktop client supporting RDP, VNC, and SSH
      ];
    };
  };
}
