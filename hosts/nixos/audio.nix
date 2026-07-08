{ ... }: {
  services.pipewire.wireplumber.extraConfig = {
    "mute-quadcast" = {
      "monitor.alsa.rules" = [
        {
          matches = [ { "node.name" = "alsa_output.usb-Kingston_HyperX_QuadCast_S_4101-00.pro-output-0"; } ];
          actions = {
            update-props = {
              "node.disabled" = true;
            };
          };
        }
      ];
    };
  };
}
