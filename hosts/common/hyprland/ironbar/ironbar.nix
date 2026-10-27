{
  pkgs,
  username,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    ironbar
  ];

  home-manager.users.${username} = {
    home.file = {
      ".config/ironbar/config.corn" = {
        enable = true;
        source = ./config/ironbar.corn;
        force = true;
      };
      ".config/ironbar/style.css" = {
        enable = true;
        source = ./config/style.css;
        force = true;
      };
    };
  };
}
