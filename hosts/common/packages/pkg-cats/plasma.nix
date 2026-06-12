{
  lib,
  pkgs,
  config,
  ...
}:
{
  options = {
    packages.drkonqi-fix.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = true;
    };
  };

  config = lib.mkIf config.packages.drkonqi-fix.enable {
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      drkonqi
    ];
    systemd.services."drkonqi-coredump-processor@".wantedBy = lib.mkForce [ ];
  };
}
