{...}:
let
  disk1 = "usb-Sabrent_Sabrent_012345678930-0:0";
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
                resumeDevice = true;
              };
            };
            root = {
              label = "nixos";
              name = "File system";
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
