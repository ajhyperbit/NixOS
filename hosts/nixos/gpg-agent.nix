{
  pkgs,
  config,
  options,
  ...
}:
{
  programs.gnupg = {
    agent = {
      enable = true;
      settings = {
        "default-cache-ttl" = 3600;
        "max-cache-ttl" = 7200;
      };
      #pinentryPackage = pkgs.pinentry-tty;
    };
  };
}
