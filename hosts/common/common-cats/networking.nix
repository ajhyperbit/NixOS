# Networking configuration
{
  lib,
  config,
  options,
  ...
}:
{
  options = {
    common.networking.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = true;
    };
  };

  config = lib.mkIf config.common.networking.enable {
    networking = {
      networkmanager.enable = true;
      enableIPv6 = false;
      timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];
      #Allow VNC and Synergy through firewall
      firewall.allowedTCPPorts = [
        5900
        24800
      ];
      #firewall.allowedUDPPorts = [ ... ];
      firewall = {
        enable = true;
        trustedInterfaces = [ "tailscale0" ];
        # required to connect to Tailscale exit nodes
        checkReversePath = "loose";
      };
    };
  };
}
