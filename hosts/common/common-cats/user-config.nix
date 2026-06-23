# User configuration
{
  lib,
  config,
  username,
  ...
}:
{
  options = {
    common.user-config.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = true;
    };
  };

  config = lib.mkIf config.common.user-config.enable {
    users.users.${username} = {
      isNormalUser = true;
      description = "AJHyperBit";
      extraGroups = [
        "flatpak"
        "disk"
        "sshd"
        "networkmanager"
        "wheel"
        "audio"
        "video"
        "greeter"
        "gamemode"
        "seat"
        "dialout"
        "ydotool"
      ];
    };
  };
}
