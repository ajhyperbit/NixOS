{
  lib,
  pkgs,
  config,
  ...
}:
{
  options = {
    packages.minecraft.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = true;
      description = ''
        Minecraft related packages
      '';
    };
  };

  config = lib.mkIf config.packages.minecraft.enable {
    environment = {
      systemPackages = with pkgs; [
        prismlauncher
      ];
    };
  };
}
