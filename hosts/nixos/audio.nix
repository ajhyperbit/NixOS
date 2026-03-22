{ ... }:
{
  services.pipewire.wireplumber.extraConfig = {
    "mute-quadcast" = {
      "monitor.alsa.rules" = [
        {
          matches = [ { "node.name" = "alsa_input.usb-Kingston_HyperX_QuadCast_S_4101-00.pro-input-0"; } ];
          actions = {
            update-props = {
              "node.muted" = true;
            };
          };
        }
      ];
    };
  };
}
