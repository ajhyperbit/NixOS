{
  config,
  pkgs,
  options,
  username,
  stateVersion-hm,
  ...
}:
{
  home = {
    stateVersion = "${stateVersion-hm}";
  };
}
