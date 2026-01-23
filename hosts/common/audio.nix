{
  config,
  pkgs,
  lib,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    pwvucontrol # Pipewire Volume Control
    easyeffects # Audio effects for PipeWire applications
  ];
  lib.mkMerge = {
    services = {
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
        extraConfig = {
          pipewire."92-low-latency" = {
            "context.properties" = {
              "default.clock.rate" = 48000;
              "default.clock.quantum" = 32;
              "default.clock.min-quantum" = 32;
              "default.clock.max-quantum" = 32;
            };
          };
          pipewire-pulse."92-low-latency" = {
            context.modules = [
              {
                name = "libpipewire-module-protocol-pulse";
                args = {
                  pulse.min.req = "32/48000";
                  pulse.default.req = "32/48000";
                  pulse.max.req = "32/48000";
                  pulse.min.quantum = "32/48000";
                  pulse.max.quantum = "32/48000";
                };
              }
            ];
            stream.properties = {
              node.latency = "32/48000";
              resample.quality = 1;
            };
          };
        };
        wireplumber = {
          configPackages = [
            (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/11-bluetooth-policy.conf" ''
              wireplumber.settings = {
                bluetooth.autoswitch-to-headset-profile = false
              }'')
          ];
          extraConfig = {
            "log-level-debug" = {
              "context.properties" = {
                # Output Debug log messages as opposed to only the default level (Notice)
                "log.level" = "D";
              };
            };
            "wh-1000xm3-ldac-hq" = {
              "monitor.bluez.rules" = [
                {
                  matches = [
                    {
                      # Match any bluetooth device with ids equal to that of a WH-1000XM3
                      "device.name" = "~bluez_card.*";
                      "device.product.id" = "0x0cd3";
                      "device.vendor.id" = "usb:054c";
                    }
                  ];
                  actions = {
                    update-props = {
                      # Set quality to high quality instead of the default of auto
                      "bluez5.a2dp.ldac.quality" = "hq";
                      #1"bluez5.auto-connect" = "[a2dp_sink]"
                      #"device.profile" = "a2dp-sink";
                    };
                  };
                }
              ];
            };
            "wh-1000xm4-ldac-hq" = {
              "monitor.bluez.rules" = [
                {
                  matches = [
                    {
                      # Match any bluetooth device with ids equal to that of a WH-1000XM6
                      "device.name" = "~bluez_card.*";
                      "device.product.id" = "0x0d58";
                      "device.vendor.id" = "usb:054c";
                    }
                  ];
                  actions = {
                    update-props = {
                      # Set quality to high quality instead of the default of auto
                      "bluez5.a2dp.ldac.quality" = "hq";
                      #1"bluez5.auto-connect" = "[a2dp_sink]"
                      #"device.profile" = "a2dp-sink";
                    };
                  };
                }
              ];
            };
            "wh-1000xm6-ldac-hq" = {
              "monitor.bluez.rules" = [
                {
                  matches = [
                    {
                      # Match any bluetooth device with ids equal to that of a WH-1000XM6
                      "device.name" = "~bluez_card.*";
                      "device.product.id" = "0x0f8a";
                      "device.vendor.id" = "usb:054c";
                    }
                  ];
                  actions = {
                    update-props = {
                      # Set quality to high quality instead of the default of auto
                      "bluez5.a2dp.ldac.quality" = "hq";
                      #1"bluez5.auto-connect" = "[a2dp_sink]"
                      #"device.profile" = "a2dp-sink";
                    };
                  };
                }
              ];
            };
          };
        };
      };
    };
  };
}
