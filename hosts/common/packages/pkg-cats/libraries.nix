{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
{
  options = {
    packages.libraries.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = true;
    };
  };

  config = lib.mkIf config.packages.libraries.enable {
    environment = {
      systemPackages = with pkgs; [
        # ── Qt Libraries ──────────────────────────────────────────────────────────
        gsettings-qt # GSettings bindings for Qt applications
        qt6Packages.qt6ct # Qt6 appearance and style configuration tool
        qt6.qt5compat # Qt5 compatibility layer for Qt6 applications
        qt6.qtbase # Qt6 base module
        qt6.qtquick3d # Qt6 Quick 3D rendering module
        qt6.qtwayland # Qt6 Wayland platform integration
        qt6.qtdeclarative # Qt6 QML and Qt Quick module
        qt6.qtsvg # Qt6 SVG rendering module
        inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default # Scriptable Wayland shell component toolkit

        # ── Vulkan ────────────────────────────────────────────────────────────────
        vulkan-loader # Vulkan ICD loader
        vulkan-validation-layers # Vulkan validation layers for debugging and development
        vulkan-tools # Vulkan utilities (vulkaninfo, vkcube)

        # ── Libraries & System Dependencies ──────────────────────────────────────
        glib # GLib core library (required for gsettings to work)
        libappindicator # Status indicator/tray applet library
        openssl # TLS/SSL cryptography library (required by Rainbow borders)
        libsecret # Library for storing and retrieving secrets via keyring
        egl-wayland # EGL Wayland platform support (NVIDIA Wayland compatibility)
        polkit # Authorization framework for privileged operations
        xdg-user-dirs # Manage XDG user directories (Downloads, Pictures, etc.)
        xdg-utils # XDG command-line tools (xdg-open, xdg-mime, etc.)
        xdg-desktop-portal-gtk # GTK backend for the XDG desktop portal
        libei # Input emulation library
        libportal # XDG portal convenience library
        service-wrapper # Wrapper for running commands as systemd services
      ];
    };
  };
}
