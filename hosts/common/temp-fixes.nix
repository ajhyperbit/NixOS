{ lib, ... }: {
  #nixpkgs issue: 514113
  #nixpkgs related pr: 510494
  nixpkgs.overlays = [
    (_: prev: {
      openldap = prev.openldap.overrideAttrs {
        doCheck = !prev.stdenv.hostPlatform.isi686;
      };
    })
  ];

  programs.firefox.enable = lib.mkForce false;
}
