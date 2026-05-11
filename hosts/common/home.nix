{
  pkgs,
  username,
  lib,
  cursor_theme,
  cursor_size,
  ...
}:
#LINK - https://discourse.nixos.org/t/how-to-manage-dotfiles-with-home-manager/30576
#LINK - https://home-manager-options.extranix.com/?query=xdg&release=release-24.05
#LINK - https://github.com/nix-community/home-manager/issues/2085#issuecomment-2022239332
#LINK - https://discourse.nixos.org/t/tell-gtk-apps-to-use-dark-mode-in-plasma/30831
{
  fonts.fontconfig.enable = true;

  username = "${username}";
  homeDirectory = "/home/${username}";
  stateVersion = lib.mkDefault "24.05";
  pointerCursor = {
    x11.enable = true;
    name = "${cursor_theme}";
    package = pkgs.rose-pine-cursor;
    size = cursor_size;
  };
  home.file.".config/qt6ct/qt6ct.conf".text = ''

    [Appearance]
    color_scheme_path=/home/${username}/.config/qt6ct/style-colors.conf
    custom_palette=true
    icon_theme=breeze-dark
    standard_dialogs=default
    style=Breeze

    [Fonts]
    fixed="Fira Code Medium,12,-1,5,500,0,0,0,0,0,0,0,0,0,0,1"
    general="Fira Code Medium,14,-1,5,500,0,0,0,0,0,0,0,0,0,0,1"

    [Interface]
    activate_item_on_single_click=1
    buttonbox_layout=0
    cursor_flash_time=1000
    dialog_buttons_have_icons=1
    double_click_interval=400
    gui_effects=@Invalid()
    keyboard_scheme=2
    menus_have_icons=true
    show_shortcuts_in_context_menus=true
    stylesheets=@Invalid()
    toolbutton_style=4
    underline_shortcut=1
    wheel_scroll_lines=3

    [SettingsWindow]
    geometry=@ByteArray(\x1\xd9\xd0\xcb\0\x3\0\0\0\0\n\0\0\0\0\0\0\0\xf\xff\0\0\x3\xee\0\0\n\0\0\0\0\0\0\0\xf\xff\0\0\x3\xee\0\0\0\0\x2\0\0\0\n\0\0\0\n\0\0\0\0\0\0\0\xf\xff\0\0\x3\xee)

    [Troubleshooting]
    force_raster_widgets=1
    ignored_applications=@Invalid()
  '';
  home.file.".config/qt6ct/style-colors.conf".text = ''

    [ColorScheme]
    active_colors=#fffcfcfc, #ff292c30, #ff40464c, #ff33383c, #ff101112, #ff1c1e21, #fffcfcfc, #ffffffff, #fffcfcfc, #ff141618, #ff202326, #ff0b0c0d, #ff3daee9, #fffcfcfc, #ff1d99f3, #ff9b59b6, #ff1d1f22, #ff000000, #ff292c30, #fffcfcfc, #ffa1a9b1, #ff3daee9
    disabled_colors=#ffbebebe, #ffefefef, #ffffffff, #ffcacaca, #ffbebebe, #ffb8b8b8, #ffbebebe, #ffffffff, #ffbebebe, #ffefefef, #ffefefef, #ffb1b1b1, #ff919191, #ffffffff, #ff0000ff, #ffff00ff, #fff7f7f7, #ff000000, #ffffffdc, #ff000000, #80000000, #ff919191
    inactive_colors=#fffcfcfc, #ff292c30, #ff40464c, #ff33383c, #ff101112, #ff1c1e21, #fffcfcfc, #ffffffff, #fffcfcfc, #ff141618, #ff202326, #ff0b0c0d, #ff3daee9, #fffcfcfc, #ff1d99f3, #ff9b59b6, #ff1d1f22, #ff000000, #ff292c30, #fffcfcfc, #ffa1a9b1, #ff3daee9
  '';
}
