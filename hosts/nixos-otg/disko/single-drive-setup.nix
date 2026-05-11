{ ... }:
let
  disk1 = "/dev/disk/by-id/usb-Sabrent_Sabrent_012345678930-0:0";
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
            BIOS = {
              name = "EFI";
              size = "2M";
              type = "EF02";
            };
            ESP = {
              label = "boot";
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
              name = "swap";
              size = "32G";
              content = {
                type = "swap";
              };
            };
            root = {
              label = "nixos-otg";
              name = "nixos-otg";
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
# sudo nix --experimental-features "nix-command flakes" run 'github:nix-community/disko/latest#disko-install' --
#--flake ../NixOS/#nixos-otg --disk '/dev/disk/by-id/usb-Sabrent_Sabrent_012345678930-0:0' /dev/disk/by-id/usb-Sabrent_Sabrent_012345678930-0:0
