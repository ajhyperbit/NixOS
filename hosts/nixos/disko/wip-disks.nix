{ config, ... }:

let
  disk4 = "/dev/disk/by-id/ata-ST2000NE0025-2FL101_ZDS1968N";
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
                  "/mnt/DATA/active" = {
                    mountpoint = "/DATA";
                    mountOptions = [
                      "compress=zstd"
                      "users"
                      "nofail"
                      "exec"
                    ];
                  };
                  "/mnt/DATA/.snapshots" = {
                    mountpoint = "/DATA/.snapshots";
                    mountOptions = [
                      "compress=zstd"
                      "users"
                      "nofail"
                      "noatime"
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
