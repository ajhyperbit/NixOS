{
  pkgs,
  inputs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    inputs.noctaliav4.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  home-manager.users.ajhyperbit = {
    # import the home manager modules
    imports = [
      inputs.noctaliav4.homeModules.default
      inputs.noctaliav5.homeModules.default
    ];

    #v4
    programs.noctalia-shell = {
      enable = true;
      settings = builtins.fromJSON (builtins.readFile ./config/noctalia.json);
    };

    #v5
    programs.noctalia = {
      enable = true;
      # settings = builtins.fromJSON (builtins.readFile ./config/noctalia.json)
    };
  };
}
