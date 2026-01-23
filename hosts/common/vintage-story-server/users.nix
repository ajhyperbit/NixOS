#This file is likely not finalized
{
  pkgs,
  ...
}:
{
  users = {
    users."vintagestory" = {
      homeMode = "755";
      isNormalUser = true;
      extraGroups = [
        "vintagestory"
      ];

      # define user packages here
      packages = with pkgs; [
      ];
    };

    defaultUserShell = pkgs.zsh;
  };
}
