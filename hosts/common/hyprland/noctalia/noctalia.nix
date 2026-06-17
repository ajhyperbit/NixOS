{
  pkgs,
  inputs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  home-manager.users.ajhyperbit = {
    # import the home manager module
    imports = [
      inputs.noctalia.homeModules.default
    ];

    # configure options
    
    programs.noctalia-shell = {
      enable = true;
      settings = builtins.fromJSON (builtins.readFile ./config/noctalia.json);
    };


    # v5
    # programs.noctalia = {
    #   enable = true;
    #   # settings = builtins.fromJSON (builtins.readFile ./config/noctalia.json);
    # };
  };
}
