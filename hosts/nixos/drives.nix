{ username, ... }: {
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

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/f3276570-2ce9-4e12-ab06-61c7cf10dfeb";
    fsType = "ext4";
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/5b448087-dd9e-4631-9c8c-39851229c1b6"; }
  ];

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

  fileSystems."/run/media/${username}/Archive-snapshots" = {
    device = "/dev/disk/by-uuid/9074e293-b54e-4139-b991-7a8064533f66";
    fsType = "btrfs";
    options = [
      "subvol=archive-snapshots"
      "noatime"
      "space_cache=v2"
      "users"
      "nofail"
      "exec"
    ];
  };

  fileSystems."/run/media/${username}/Archive-typical" = {
    device = "/dev/disk/by-uuid/9074e293-b54e-4139-b991-7a8064533f66";
    fsType = "btrfs";
    options = [
      "subvol=archive-typical"
      "compress=zstd:3"
      "noatime"
      "space_cache=v2"
      "users"
      "nofail"
      "exec"
    ];
  };

  services.btrbk.instances."archive-typical" = {
    onCalendar = "weekly";
    settings = {
      snapshot_preserve_min = "30d";
      snapshot_preserve = "6m";
      volume."/run/media/${username}/Archive-typical" = {
        subvolume = ".";
        snapshot_dir = "/run/media/${username}/Archive-snapshots/typical";
      };
    };
  };

  fileSystems."/run/media/${username}/Archive-max" = {
    device = "/dev/disk/by-uuid/9074e293-b54e-4139-b991-7a8064533f66";
    fsType = "btrfs";
    options = [
      "subvol=archive-max"
      "compress-force=zstd:15"
      "noatime"
      "space_cache=v2"
      "users"
      "nofail"
      "exec"
    ];
  };

  services.btrbk.instances."archive-max" = {
    onCalendar = "weekly";
    settings = {
      snapshot_preserve_min = "30d";
      snapshot_preserve = "6m";
      volume."/run/media/${username}/Archive-max" = {
        subvolume = ".";
        snapshot_dir = "/run/media/${username}/Archive-snapshots/max";
      };
    };
  };
}
