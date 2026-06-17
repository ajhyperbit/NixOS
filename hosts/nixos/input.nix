{ pkgs, ... }: {
  # Enable IME
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = [ pkgs.fcitx5-mozc ];
  };

  # Install fonts
  fonts.packages = with pkgs; [
    corefonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    ipafont
  ];

  # Set default fonts
  lib.mkMerge = {
    fonts.fontconfig.defaultFonts = {
      monospace = [
        "Hack Nerd Font"
        "Noto Sans Mono CJK JP"
      ];

      sansSerif = [
        "Noto Sans"
        "Noto Sans CJK JP"
      ];

      serif = [
        "Noto Serif"
        "Noto Serif CJK JP"
      ];
    };
  };
}
