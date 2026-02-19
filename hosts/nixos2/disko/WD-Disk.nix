{ config, ... }:
let
  disk1 = "/dev/disk/by-id/nvme-WD_BLACK_SN850X_1000GB_25463T800234";
in
{
  disko.devices = {
    disk = {
      ${disk1} = {
        type = "disk";
        device = "${disk1}";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name = "ESP";
              size = "4G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "fat32";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              size = "25%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "/rootfs" = {
                    mountpoint = "/";
                  };
                };
              };
              mountpoint = "/partition-root";
            };
            nix = {
              size = "25%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                };
              };
              mountpoint = "/partition-nix";
            };
            home = {
              size = "50%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "/home" = {
                    mountOptions = [ "compress=zstd" ];
                    mountpoint = "/home";
                  };
                  "/home/ajhyperbit" = {
                  };
                };
              };
              mountpoint = "/partition-home";
            };
            swap = {
              size = "72G";
              content = {
                type = "swap";
                discardPolicy = "both";
                resumeDevice = true;
              };
            };
          };
        };
      };
    };
  };
}
