{ pkgs, ... }: {
  home-manager.users.ajhyperbit = {
    home.file."NixOS-Hyprland/hosts/common/hyprland/hl.meta.lua".source =
      "${pkgs.hyprland}/share/hypr/stubs/hl.meta.lua";
  };
}
