# Misc system settings
{
  lib,
  config,
  ...
}:
{
  options = {
    common.system-misc.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = true;
    };
  };

  config = lib.mkIf config.common.system-misc.enable {
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    documentation.nixos.enable = false;

    #home-manager.useGlobalPkgs = true;
    #home-manager.useUserPackages = true;
    #home-manager.users.${username} = { imports = [ ./config/home.nix ];};
    #home-manager.extraSpecialArgs = {inherit inputs self username;};
    #home-manager.backupFileExtension = "hm-bak";

    # zram
    zramSwap = {
      enable = true;
    };
  };
}
