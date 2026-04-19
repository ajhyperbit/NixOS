{ username, ... }:
let
  #NVMe SSD 1
  disk1 = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_500GB_S5H7NS0N583877Z";
  #NVMe SSD 2
  disk2 = "/dev/disk/by-id/nvme-WD_BLACK_SN850X_1000GB_25463T800234";
  #SATA SSD
  disk3 = "/dev/disk/by-id/ata-WDC_WDS200T2B0A_19162B802185";
  #DATA disk
  disk4 = "/dev/disk/by-id/ata-ST2000NE0025-2FL101_ZDS1968N";
  #Archive disk
  disk5 = "/dev/disk/by-id/ata-ST6000VN0033-2EE110_ZADBCVNZ";
in
{
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
              #Currently this is 512M, but it should be 1024 eventually.
              size = "512M";
              #size = "1024M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            swap = {
              label = "swap";
              name = "swap";
              size = "72G"; # SWAP
              content = {
                type = "swap";
                resumeDevice = true;
              };
            }; # I probably don't need a swap this massive.
            root = {
              label = "rootfs";
              name = "rootfs";
              size = "50%";
              content = {
                type = "filesystem";
                format = "ext4";
              };
            };
            nix = {
              label = "nix";
              name = "nix";
              size = "50%";
              content = {
                type = "filesystem";
                format = "ext4";
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
              label = "home";
              name = "homefs";
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/home";
              };
            };
          };
        };
      };
    };
    disk = {
      ${disk3} = {
        type = "disk";
        device = "${disk3}";
        content = {
          type = "gpt";
          partitions = {
            SATA_SSD = {
              label = "SATA_SSD";
              name = "SATA_SSD";
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/run/media/${username}/SATA_SSD";
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
                type = "filesystem";
                format = "ext4";
                mountpoint = "/run/media/${username}/DATA";
              };
            };
          };
        };
      };
    };
  };
}
