{
  username,
  ...
}:
{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/7435c3ee-ec8c-4653-943d-f00a3f50e5a5";
    fsType = "ext4";
    #  options = [ "noatime" ];
  };

  fileSystems."/bin" = {
    device = "/usr/bin";
    fsType = "none";
    options = [ "bind" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/8BFE-691B";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/5b448087-dd9e-4631-9c8c-39851229c1b6"; }
  ];

  #fileSystems."/home" = {
  #  device = "/";
  #  options = [ "relatime" ];
  #};

  fileSystems."/run/media/${username}/SATA_SSD" = {
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
  
  fileSystems."/run/media/${username}/DATA" = {
    device = "/dev/disk/by-uuid/5fbf2ab2-4950-467b-ac78-13fbb8bf516b";
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
  #   "d     /run/media/${username}/SATA_SSD/ollama 0755 ollama 100 -   -"
  # ];

  #fileSystems."/run/media/${username}/Archive" = {
  #  device = "/dev/disk/by-uuid/4fd45309-e0dc-4124-8c19-36c011aad8eb";
  #  label = "Archive";
  #  fsType = "btrfs";
  #  options = [
  #    "users" # Allows any user to mount and unmount
  #    "nofail" # Prevent system from failing if this drive doesn't mount
  #    "exec" # Permit execution of binaries and other executable files
  #    "noauto" #Do not mount the filesystem automatically
  #  ];
  #};
}
