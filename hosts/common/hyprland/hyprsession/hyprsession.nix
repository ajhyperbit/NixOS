{ pkgs, ... }: {
  nixpkgs.overlays = [
    (final: _prev: {
      hyprsession = final.callPackage ./pkgs/hyprsession.nix { };
    })
  ];

  environment.systemPackages = with pkgs; [
    hyprsession
    # inputs.hyprsession.packages.${pkgs.system}.hyprsession
  ];

  home-manager.users.ajhyperbit = {
    home.file = {
      ".local/share/hyprsession/open-default/exec.conf".source = ./config/exec.conf;
      ".local/share/hyprsession/open-default/clients.conf".source = ./config/clients.json;
    };
  };
}
