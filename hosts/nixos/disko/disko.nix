{
  disko.devices = {
    disk = {
      root = {
        type = "disk";
        #device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_500GB_S5H7NS0N583877Z"; #FIXME - needs disk
        content = {
          type = "gpt";
          partitions = {
            EFI = {
              start = "2MiB";
              end = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                #mountpoint = "/boot";
              };
            };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ]; # Override existing partition
                # Subvolumes must set a mountpoint in order to be mounted,
                # unless their parent is mounted
                subvolumes = {
                  "@" = { };
                  "@/root" = {
                    #mountpoint = "/";
                    mountOptions = [
                      "compress=zstd" # Enable default zstd compression
                      "noatime"
                    ];
                  };
                  "@/nix" = {
                    #mountpoint = "/nix";
                    mountOptions = [
                      "compress=zstd" # Enable default zstd compression
                      "noatime"
                    ];
                  };
                  "@/home" = {
                    #mountpoint = "/home";
                    mountOptions = [
                      "compress=zstd" # Enable default zstd compression
                    ];
                  };

                  "@/.snapshots" = {
                    #mountpoint = "/.snapshots";
                    mountOptions = [
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
    #disk = {
    #  home = {
    #    type = "disk";
    #    #device = ""; #FIXME - needs disk
    #    content = {
    #      type = "gpt";
    #      partitions = {
    #        home = {
    #          size = "100%";
    #          content = {
    #            type = "btrfs";
    #            extraArgs = ["-f"];
    #            subvolumes = {
    #              "@" = {};
    #              "@/home" = {
    #                mountpoint = "/home";
    #                mountOptions = [
    #                  "compress=zstd"
    #                ];
    #              };
    #              "@/.snapshots" = {
    #                mountOptions = [
    #                  "compress=zstd"
    #                ];
    #              };
    #            };
    #          };
    #        };
    #      };
    #    };
    #  };
    #};
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
                    mountpoint = "/run/media/ajhyperbit/DATA";
                    mountOptions = [
                      "compress=zstd" # Enable default zstd compression
                    ];
                  };
                  #"@/DATA" = {
                  #  mountpoint = "/run/media/ajhyperbit/DATA";
                  #  mountOptions = [
                  #    "compress=zstd" #Enable default zstd compression
                  #  ];
                  "@/.snapshots" = {
                    mountOptions = [
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
    #disk = {
    #  SATASSD = {
    #    type = "disk";
    #    #device = "/dev/disk/by-id/ata-WDC_WDS200T2B0A_19162B802185"; #REVIEW - Check disk
    #    content = {
    #      type = "gpt";
    #      partitions = {
    #        SATASSD = {
    #          size = "100%";
    #          content = {
    #            type = "btrfs";
    #            extraArgs = ["-f"]; # Override existing partition
    #            # Subvolumes must set a mountpoint in order to be mounted,
    #            # unless their parent is mounted
    #            subvolumes = {
    #              "@" = {};
    #              "@/SATA SSD" = {
    #                mountpoint = "/run/media/ajhyperbit/SATA SSD";
    #                mountOptions = [
    #                  "users" # Allows any user to mount and unmount
    #                  "nofail" # Prevent system from failing if this drive doesn't mount
    #                  "exec" # Permit execution of binaries and other executable files
    #                  "auto" #Mount the filesystem automatically
    #                  "compress=zstd" #Enable default zstd compression
    #                ];
    #              };
    #              "/.snapshots" = {
    #                mountpoint = "/run/media/ajhyperbit/SATA SSD/.snapshots";
    #                mountOptions = [
    #                  "users" # Allows any user to mount and unmount
    #                  "nofail" # Prevent system from failing if this drive doesn't mount
    #                  "exec" # Permit execution of binaries and other executable files
    #                  "auto" #Mount the filesystem automatically
    #                  "compress=zstd" #Enable default zstd compression
    #                ];
    #              };
    #            };
    #          };
    #        };
    #      };
    #    };
    #  };
    #};
    #disk = {
    #  Archive = {
    #    type = "disk";
    #    #device = "/dev/disk/by-id/ata-ST6000VN0033-2EE110_ZADBCVNZ"; #FIXME - needs disk
    #    content = {
    #      type = "gpt";
    #      partitions = {
    #        Archive = {
    #          size = "100%";
    #          content = {
    #            type = "btrfs";
    #            extraArgs = ["-f"]; # Override existing partition
    #            # Subvolumes must set a mountpoint in order to be mounted,
    #            # unless their parent is mounted
    #            subvolumes = {
    #              # Subvolume name is different from mountpoint
    #              "@" = {};
    #              "@/Archive" = {
    #                mountpoint = "/run/media/ajhyperbit/Archive";
    #                mountOptions = [
    #                  "compress=zstd" #Enable default zstd compression
    #                ];
    #              };
    #              "@/.snapshots" = {
    #                mountOptions = [
    #                  "compress=zstd"
    #                ];
    #              };
    #            };
    #          };
    #        };
    #      };
    #    };
    #  };
    #};
  };
}
