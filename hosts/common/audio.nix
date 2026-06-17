{
  pkgs,
  lib,
  config,
  ...
}:
let
  defaultMatchCriteria = {
    "device.name" = "~bluez_card.*";
    "device.vendor.id" = "usb:054c";
  };
  bt_headset_props = {
    # Set quality to high quality instead of the default of auto
    "bluez5.a2dp.ldac.quality" = "hq";
    #"bluez5.auto-connect" = "[a2dp_sink]"
    #"device.profile" = "a2dp-sink";
  };
in
{
  options.audio.disableHfpHsp = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Disable HFP/HSP bluetooth profiles in WirePlumber. Set to false to re-enable voice/call profiles.";
  };

  config = {
    environment.systemPackages = with pkgs; [
      pwvucontrol
      easyeffects
    ];

    services.pipewire = {
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
            "default.clock.max-quantum" = 512;
          };
        };
        pipewire-pulse."92-low-latency" = {
          context.modules = [
            {
              name = "libpipewire-module-protocol-pulse";
              args = {
                pulse.min.req = "32/48000";
                pulse.default.req = "32/48000";
                pulse.max.req = "512/48000";
                pulse.min.quantum = "32/48000";
                pulse.max.quantum = "512/48000";
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
        extraConfig = lib.mkMerge [
          (lib.mkIf config.audio.disableHfpHsp {
            "disable-hfphsp" = {
              "monitor.bluez.properties" = {
                "bluez5.hfphsp-backend" = "none";
              };
            };
          })
          {
            "log-level-debug" = {
              "context.properties" = {
                "log.level" = "D";
              };
            };

            "99-audio-device-priority" = {
              "monitor.bluez.rules" = [
                {
                  matches = [
                    (defaultMatchCriteria // { "device.product.id" = "0x0cd3"; })
                    (defaultMatchCriteria // { "device.product.id" = "0x0d58"; })
                    (defaultMatchCriteria // { "device.product.id" = "0x0f8a"; })
                  ];
                  actions.update-props = {
                    "priority.session" = 2000;
                  };
                }
              ];

              "monitor.alsa.rules" = [
                {
                  matches = [
                    #preferred fallback ALSA sink
                    { "node.name" = "alsa_output.pci-0000_0f_00.4.analog-stereo"; }
                  ];
                  actions.update-props = {
                    "priority.session" = 1500;
                  };
                }
              ];
            };

            "wh-1000xm3-ldac-hq" = {
              "monitor.bluez.rules" = [
                {
                  # Match any bluetooth device with ids equal to that of a WH-1000XM3
                  matches = [ (defaultMatchCriteria // { "device.product.id" = "0x0cd3"; }) ];
                  actions.update-props = bt_headset_props;
                }
              ];
            };
            "wh-1000xm4-ldac-hq" = {
              "monitor.bluez.rules" = [
                {
                  # Match any bluetooth device with ids equal to that of a WH-1000XM4
                  matches = [ (defaultMatchCriteria // { "device.product.id" = "0x0d58"; }) ];
                  actions.update-props = bt_headset_props;
                }
              ];
            };
            "wh-1000xm6-ldac-hq" = {
              "monitor.bluez.rules" = [
                {
                  # Match any bluetooth device with ids equal to that of a WH-1000XM6
                  matches = [ (defaultMatchCriteria // { "device.product.id" = "0x0f8a"; }) ];
                  actions.update-props = bt_headset_props;
                }
              ];
            };
          }
        ];
      };
    };
  };
}
