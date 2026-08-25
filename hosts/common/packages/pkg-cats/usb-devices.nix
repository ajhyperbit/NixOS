{
  lib,
  pkgs,
  config,
  ...
}:
{
  options = {
    packages.usb-devices.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = true;
      description = ''
        USB and input device tooling: libratbag and Piper for gaming
        mice, the overskride Bluetooth manager, and Android platform
        tools (adb, fastboot).
      '';
    };
  };

  config = lib.mkIf config.packages.usb-devices.enable {
    environment = {
      systemPackages = with pkgs; [
        # ── Input Devices ─────────────────────────────────────────────────────────
        libratbag # Configuration driver for gaming mice
        piper # GTK frontend for libratbag gaming mouse configuration

        # ── Bluetooth ─────────────────────────────────────────────────────────────
        overskride # Bluetooth manager with a clean GTK/Wayland interface

        # ── Android & USB Tools ───────────────────────────────────────────────────
        android-tools # ADB, fastboot, and other Android platform tools
      ];
    };
  };
}
