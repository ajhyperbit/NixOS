{
  self,
  pkgs,
  ...
}:
{
  environment.systemPackages =
    with self.inputs.nix-alien.packages.${pkgs.stdenv.hostPlatform.system}; [
      nix-alien
    ];
}
