{
  lib,
  pkgs,
  config,
  ...
}:
{
  options = {
    packages.wine.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = true;
    };
  };

  config = lib.mkIf config.packages.wine.enable {
    environment = {
      systemPackages = with pkgs; [
        # ── Wine & Compatibility Layer ────────────────────────────────────────────
        wine # Windows compatibility layer (32-bit)
        wine64 # Windows compatibility layer (64-bit)
        wine-staging # Wine with staging patches for improved game compatibility
        wine-wayland # Wine with native Wayland driver support
        winetricks # Install Windows libraries and components into Wine prefixes
        protontricks # Winetricks wrapper for Steam/Proton prefixes
        (bottles.override {
          # Wine prefix manager with per-application profiles
          removeWarningPopup = true;
        })
      ];
    };
  };
}
