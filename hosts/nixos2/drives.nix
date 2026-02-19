{
  config,
  pkgs,
  host,
  username,
  options,
  lib,
  inputs,
  system,
  ...
}:
{
  fileSystems."/run/media/ajhyperbit/SATA_SSD" = {
    device = "/dev/disk/by-uuid/c879995c-386a-42c2-bc3b-8d02a03c61de";
    fsType = "ext4";
    options = [
      # If you don't have this options attribute, it'll default to "defaults"
      # boot options for fstab. Search up fstab mount options you can use
      "users" # Allows any user to mount and unmount
      "nofail" # Prevent system from failing if this drive doesn't mount
      "exec" # Permit execution of binaries and other executable files
    ];
  };

  # systemd.tmpfiles.rules = [
  #   # Type Path                                  Mode UID    GID Age Argument
  #   "d     /run/media/ajhyperbit/SATA_SSD/ollama 0755 ollama 100 -   -"
  # ];
  systemd.tmpfiles.settings = {
    "ollamaConfig" = {
      "/run/media/ajhyperbit/SATA_SSD/ollama" = {
        d = {
          group = "users";
          mode = "0755";
          user = "ollama";
        };
      };
    };
  };
}
