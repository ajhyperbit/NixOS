{
  config,
  pkgs,
  options,
  username,
  lib,
  inputs,
  system,
  cursor_theme,
  cursor_size,
  ...
}:
{
  fonts.fontconfig.enable = true;

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    packages = with pkgs; [
    ];
    stateVersion = lib.mkDefault "24.05";
  };

  #LINK - https://discourse.nixos.org/t/how-to-manage-dotfiles-with-home-manager/30576
  #LINK - https://home-manager-options.extranix.com/?query=xdg&release=release-24.05

  #LINK - https://github.com/nix-community/home-manager/issues/2085#issuecomment-2022239332

  #options = {
  #  dotfiles = lib.mkOption {
  #    type = lib.types.path;
  #    apply = toString;
  #    default = "${config.home.homeDirectory}/NixOS-Hyprland";
  #    #example = "${config.home.homeDirectory}/NixOS-Hyprland";
  #    description = "Location of the dotfiles working copy";
  #  };
  #};

  #xdg.configFile."ags".source = config.lib.file.mkOutOfStoreSymlink "${options.dotfiles}/config/ags";

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "${cursor_theme}";
    package = pkgs.rose-pine-cursor;
    size = cursor_size;
  };

  gtk.cursorTheme = {
    name = "${cursor_theme}";
    package = pkgs.rose-pine-cursor;
    size = cursor_size;
  };

  stylix = {
    #enable = true;
    #autoEnable = true; #default is true
    polarity = "dark";
    cursor = {
      name = "${cursor_theme}";
      package = pkgs.rose-pine-cursor;
      size = cursor_size;
    };
    targets = {
      gnome.enable = false;
      kde.enable = false;
      yazi.enable = false;
      nvf.enable = false;
    };
  };

  #https://discourse.nixos.org/t/tell-gtk-apps-to-use-dark-mode-in-plasma/30831
  #home-manager.users.ajhyperbit = {
  #  dconf.settings = {
  #    "org/gnome/desktop/interface" = {
  #      color-scheme = "prefer-dark";
  #    };
  #  };
  #  gtk = {
  #    enable = true;
  #    theme = {
  #      name = "Breeze-Dark";
  #      package = pkgs.gnome.gnome-themes-extra;
  #    };
  #  };
  #  # Wayland, X, etc. support for session vars
  #  systemd.user.sessionVariables = config.home-manager.users.justinas.home.sessionVariables;
  #};
  #qt = {
  #  enable = true;
  #  platformTheme = "gnome";
  #  style = "adwaita-dark";
  #};

  xdg = {
    enable = true;
    #userDirs = {
    #  enable = true;
    #  createDirectories = true;
    #};
    #configFile = {
    #  "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
    #  "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
    #  "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
    #};
  };
}
