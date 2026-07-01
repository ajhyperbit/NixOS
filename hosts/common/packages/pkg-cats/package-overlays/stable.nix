{ inputs, ... }: {
  nixpkgs.overlays = [
    (_final: prev: {
      stable = import inputs.nixpkgs-stable {
        inherit (prev.stdenv.hostPlatform) system;
        config.allowUnfree = true;
      };
    })
  ];
}
