# Steam package override
{
  lib,
  config,
  ...
}:
{
  options = {
    common.steam-override.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = true;
    };
  };

  config = lib.mkIf config.common.steam-override.enable {
    nixpkgs.config.packageOverrides = pkgs: {
      steam = pkgs.steam.override {
        extraPkgs =
          pkgs: with pkgs; [
            gamescope
            mangohud
          ];
      };
    };
  };
}
