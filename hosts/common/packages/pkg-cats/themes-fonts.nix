{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
{
  options = {
    packages.theme-fonts.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = true;
    };
  };

  config = lib.mkIf config.packages.theme-fonts.enable {
    environment = {
      systemPackages = with pkgs; [
        # ── Themes, Fonts & Appearance ────────────────────────────────────────────
        # gtk-engine-murrine # GTK2 Murrine engine (required by some legacy GTK themes)
        libsForQt5.qtstyleplugin-kvantum # Kvantum SVG-based theme engine for Qt5
        qt6Packages.qtstyleplugin-kvantum # Kvantum SVG-based theme engine for Qt6
        nwg-look # GTK3/4 appearance configuration tool for wlroots compositors
        font-manager # GUI font manager and viewer
        fontforge # Font editor and format conversion tool
        rose-pine-cursor # Rosé Pine cursor theme (X11/Wayland)
        inputs.rose-pine-hyprcursor.packages.${pkgs.stdenv.hostPlatform.system}.default # Rosé Pine cursor theme for Hyprland
      ];
    };
  };
}
