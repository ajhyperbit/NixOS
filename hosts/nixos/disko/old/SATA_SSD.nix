{
  disko.rootMountPoint = "/";
  disko.devices = {
    disk = {
      SATASSD = {
        type = "disk";
        device = "/dev/disk/by-id/ata-WDC_WDS200T2B0A_19162B802185";
        content = {
          type = "gpt";
          partitions = {
            SATASSD = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ]; # Override existing partition
                # Subvolumes must set a mountpoint in order to be mounted,
                # unless their parent is mounted
                subvolumes = {
                  "@" = { };
                  "@/SATA SSD" = {
                    mountpoint = "/run/media/ajhyperbit/SATA SSD";
                    mountOptions = [
                      "users" # Allows any user to mount and unmount
                      "nofail" # Prevent system from failing if this drive doesn't mount
                      "exec" # Permit execution of binaries and other executable files
                      "auto" # Mount the filesystem automatically
                      "compress=zstd" # Enable default zstd compression
                    ];
                  };
                  "/.snapshots" = {
                    mountpoint = "/run/media/ajhyperbit/SATA SSD/.snapshots";
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
          };
        };
      };
    };
  };
}
