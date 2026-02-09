{
  disko.devices = {
    disk = {
      root = {
        type = "disk";
        #device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_500GB_S58SNM0RC03948A";
        content = {
          type = "gpt";
          partitions = [
            {
              name = "EFI";
              start = "2MiB";
              end = "514MiB";
              bootable = true;
              content = {
                type = "filesystem";
                format = "fat32";
                mountpoint = "/boot";
              };
            }
            {
              root = {
                size = "100%";
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ]; # Override existing partition
                  # Subvolumes must set a mountpoint in order to be mounted,
                  # unless their parent is mounted
                  subvolumes = {
                    # Subvolume name is different from mountpoint
                    "/@root" = {
                      mountpoint = "/";
                      mountOptions = [
                        "compress=zstd" # Enable default zstd compression
                      ];
                    };
                    "/.snapshots" = {
                      mountpoint = "/.snapshots";
                      mountOptions = [
                        "users" # Allows any user to mount and unmount
                        "nofail" # Prevent system from failing if this drive doesn't mount
                        "exec" # Permit execution of binaries and other executable files
                        "auto" # Mount the filesystem automatically
                        "compress=zstd" # Enable default zstd compression
                      ];
                    };
                  };
                };
              };
            }
          ];
        };
      };
    };
  };
}
