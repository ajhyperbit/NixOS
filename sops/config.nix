{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    # age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
    age.keyFile = "/etc/sops/age/keys.txt";
  };

  environment.systemPackages = with pkgs; [
    age
    sops
  ];
}
