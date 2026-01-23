{
  disko.devices = {
    disk = {
      home = {
        type = "disk";
        #device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_500GB_S5H7NS0N583877Z";
        content = {
          type = "gpt";
          partitions = [
            {
              home = {
                size = "100%";
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ]; # Override existing partition
                  # Subvolumes must set a mountpoint in order to be mounted,
                  # unless their parent is mounted
                  subvolumes = {
                    # Subvolume name is different from mountpoint
                    "/@home" = {
                      mountpoint = "/home";
                      mountOptions = [
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
