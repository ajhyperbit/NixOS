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
      description = ''
        Workaround that excludes KDE's drkonqi crash handler from the
        Plasma 6 package set and disables the drkonqi coredump processor
        systemd unit.
      '';
    };
  };

  config = lib.mkIf config.packages.drkonqi-fix.enable {
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      drkonqi
    ];
    systemd.services."drkonqi-coredump-processor@".wantedBy = lib.mkForce [ ];
  };
}
