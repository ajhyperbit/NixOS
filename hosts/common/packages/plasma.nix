{
  lib,
  pkgs,
  ...
}:
{
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    drkonqi
  ];
  systemd.services."drkonqi-coredump-processor@".wantedBy = lib.mkForce [ ];
}
