{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    #./temp-hyprland.nix
    inputs.hyprland.nixosModules.default
  ];

  programs = {
    #Hyprland
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
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
          user = "greeter";
          command = "${pkgs.tuigreet}/bin/tuigreet --time -w 120 --cmd '${pkgs.uwsm}/bin/uwsm start hyprland-uwsm.desktop' --power-reboot 'sudo systemctl kexec' --kb-command 2 --kb-sessions 3 --kb-power 12";
        };
      };
    };
  };

  environment.etc."greetd/sessions/hyprland.desktop".text = ''
    [Desktop Entry]
    Name=Hyprland UWSM custom
    Exec=${pkgs.uwsm}/bin/uwsm start hyprland-uwsm.desktop
    Type=Application
  '';

  environment.sessionVariables = rec {
    QML_IMPORT_PATH = "${pkgs.hyprland-qt-support}/lib/qt-6/qml";
    HYPRCURSOR_SIZE = 32; # {cursor_size};
    HYPRCURSOR_THEME = "rose-pine-hyprcursor";
  };

  home-manager.users.ajhyperbit = {
    home.file."NixOS-Hyprland/hosts/common/hyprland/hl.meta.lua".source =
      "${pkgs.hyprland}/share/hypr/stubs/hl.meta.lua";
  };
}
