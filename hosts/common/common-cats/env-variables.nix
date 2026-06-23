# Environment variables
{
  lib,
  pkgs,
  config,
  cursor_theme,
  ...
}:
{
  options = {
    common.env-variables.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = true;
    };
  };

  config = lib.mkIf config.common.env-variables.enable {
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

      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      QT_STYLE_OVERRIDE = "Breeze";
      QT_QPA_PLATFORMTHEME = "qt6ct";
      GDK_BACKEND = "wayland,x11,";
    };
  };
}
