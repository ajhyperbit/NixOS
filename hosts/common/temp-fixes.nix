{ pkgs, ... }:
{
  #nixpkgs issue: 487054
  #https://nixpkgs-tracker.ocfox.me/?pr=487054
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

  #nixpkgs issue: 493679
  #https://nixpkgs-tracker.ocfox.me/?pr=493679
  nixpkgs.overlays = [
    (final: prev: {
      pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
        (python-final: python-prev: {
          picosvg = python-prev.picosvg.overridePythonAttrs (_: {
            doCheck = false;
          });
        })
      ];
    })
  ];

  #nixpkgs issue: 493384
  #https://nixpkgs-tracker.ocfox.me/?pr=493384
  services.sunshine.package = pkgs.sunshine.override {
    boost = pkgs.boost187;
  };
}
