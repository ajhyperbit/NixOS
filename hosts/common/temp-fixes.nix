{ pkgs, ... }:
{
  #nixpkgs issue: 487054
  systemd.services.gfxrace = {
    before = [ "ollama.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.coreutils}/bin/sleep 10";
    };
    wantedBy = [ "multi-user.target" ];
    restartIfChanged = false;
  };

  #nixpkgs pr: 493384
  #https://nixpkgs-tracker.ocfox.me/?pr=493384
  # services.sunshine.package = pkgs.sunshine.override {
  #   boost = pkgs.boost187;
  # };

  #nixpkgs issue: 514113
  #nixpkgs related pr: 510494
  nixpkgs.overlays = [
    (_: prev: {
      openldap = prev.openldap.overrideAttrs {
        doCheck = !prev.stdenv.hostPlatform.isi686;
      };
    })
  ];
}
