{
  config,
  pkgs,
  username,
  ...
}: let
  inherit (import ./variables.nix) gitEmail;
in {
  programs.git = {
    enable = true;
    config = {
      init = {
        defaultBranch = "main";
      };
      user = {
        name = "${username})";
        email = "${gitEmail}";
      };
      commit.gpgsign = "true";
    };
  };
}
