{
  lib,
  config,
  ...
}:
let
  disk1 = "/dev/disks/by-id/nvme-Samsung_SSD_970_EVO_500GB_S5H7NS0N583877Z";
  disk2 = "/dev/vda"; # Intentionally left unset for now.
  disk3 = "/dev/disks/by-id/ata-WDC_WDS200T2B0A_19162B802185";
  disk4 = "/dev/disks/by-id/ata-ST2000NE0025-2FL101_ZDS1968N";
  disk5 = "/dev/disks/by-id/ata-ST6000VN0033-2EE110_ZADBCVNZ";
in
{

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

  systemd.tmpfiles.rules = [
    # Type Path                                  Mode UID    GID Age Argument
    "d     /run/media/ajhyperbit/SATA_SSD/ollama 0755 ollama 100 -   -"
  ];

  disko.devices = {
    disk = {
      ${disk1} = {
        device = "${disk1}";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              label = "EFI";
              name = "ESP";
              size = "1024M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            swap = {
              label = "swap";
              size = "72G"; # SWAP
              content = {
                type = "swap";
                resumeDevice = true;
              };
            };
            root = {
              label = "rootfs";
              name = "btrfs";
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "/root" = { };
                  "/root/rootfs" = {
                    mountpoint = "/";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "/root/snapshots" = {
                    mountpoint = "/.snapshots";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = [
                      "compress=zstd"
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
    disk = {
      ${disk2} = {
        device = "${disk2}";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            home = {
              label = "homefs";
              name = "home";
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "/home" = { };
                  "/home/active" = {
                    mountpoint = "/home";
                    mountOptions = [
                      "compress=zstd"
                    ];
                  };
                  "/home/snapshots" = {
                    mountpoint = "/home/.snapshots";
                    mountOptions = [
                      "compress=zstd"
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
  };
}
