{
  disko.rootMountPoint = "/";
  disko.devices = {
    disk = {
      DATA = {
        type = "disk";
        device = "/dev/disk/by-id/ata-ST2000NE0025-2FL101_ZDS1968N";
        content = {
          type = "gpt";
          partitions = {
            DATA = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ]; # Override existing partition
                # Subvolumes must set a mountpoint in order to be mounted,
                # unless their parent is mounted
                subvolumes = {
                  # Subvolume name is different from mountpoint
                  "@" = {
                    mountpoint = "/home/ajhyperbit/media/DATA";
                    mountOptions = [
                      "compress=zstd" # Enable default zstd compression
                    ];
                  };
                  #"@/DATA" = {
                  #  mountpoint = "/run/media/ajhyperbit/DATA";
                  #  mountOptions = [
                  #    "compress=zstd" #Enable default zstd compression
                  #  ];
                  #"@/.snapshots" = {
                  #  mountpoint = "";
                  #  mountOptions = [
                  #    "compress=zstd" #Enable default zstd compression
                  #  ];
                  #};
                };
              };
            };
          };
        };
      };
    };
  };
}
