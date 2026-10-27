{
  pkgs,
  inputs,
  username,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    ironbar
  ];

  home-manager.users.${username}.xdg.configFile."ironbar-css" = {
    enable = false;
    source = "./config/ironbar/style.css";
    target = "ironbar/style.css";
  }
}
