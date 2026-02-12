{ config, ... }:

let
  disk4 = "/dev/disk/by-id/ata-ST2000NE0025-2FL101_ZDS1968N";
  disk5 = "/dev/disks/by-id/ata-ST6000VN0033-2EE110_ZADBCVNZ";
in
{
  disko.devices = {
    disk = {
      ${disk4} = {
        type = "disk";
        device = "${disk4}";
        content = {
          type = "gpt";
          partitions = {
            DATA = {
              label = "DATA";
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "/mnt/DATA" = { };
                  "/DATA/rootfs" = {
                    mountpoint = "/DATA";
                    mountOptions = [
                      "compress=zstd"
                      "nofail"
                    ];
                  };
                  "/DATA/.snapshots" = {
                    mountpoint = "/DATA/.snapshots";
                    mountOptions = [
                      "compress=zstd"
                      "nofail"
                    ];
                  };
                };
              };
            };
          };
        };
      };
    };
    disk = {
      ${disk5} = {
        type = "disk";
        device = "${disk5}";
        content = {
          type = "gpt";
          partitions = {
            DATA = {
              label = "Archive";
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "/mnt/Archive" = { };
                  "/Archive/rootfs" = {
                    mountpoint = "/Archive";
                    mountOptions = [
                      "compress=zstd"
                      "nofail"
                    ];
                  };
                  "/Archive/.snapshots" = {
                    mountpoint = "/Archive/.snapshots";
                    mountOptions = [
                      "compress=zstd"
                      "nofail"
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
