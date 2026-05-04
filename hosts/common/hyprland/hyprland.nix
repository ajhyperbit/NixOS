{
  lib,
  pkgs,
  inputs,
  username,
  ...
}:
{
  imports = [
    ./temp-hyprland.nix
    inputs.hyprland.nixosModules.default
  ];

  programs = {
    #Hyprland
    hyprland = {
      enable = true;
      # package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland.override {
      #   withSystemd = true;
      # };
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland; # xdphls
      xwayland.enable = true;
      withUWSM = true;
    };
    #waybar.enable = true; # has some kind of race condition when used in the Hyprland UWSM env
    hyprlock.enable = true;
  };

  services = {
    #Hyprland
    hypridle.enable = true;

    greetd = {
      settings = {
        default_session = {
          user = username;
          command = ''
            ${pkgs.tuigreet}/bin/tuigreet --time -w 120 --cmd "${pkgs.uwsm}/bin/uwsm start hyprland-uwsm.desktop" --power-reboot 'sudo systemctl kexec'
          '';
        };
      };
    };
  };

  environment.sessionVariables = rec {
    QML_IMPORT_PATH = "${pkgs.hyprland-qt-support}/lib/qt-6/qml";
    HYPRCURSOR_SIZE = 32; # {cursor_size};
    HYPRCURSOR_THEME = "rose-pine-hyprcursor";
  };
}
