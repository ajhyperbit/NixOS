{ lib, ... }:
{
  options = {
    webhost = {
      enable = lib.mkEnableOption "Enable webhost services";

      domain = lib.mkOption {
        type = lib.types.str;
        default = "example.com";
        description = "Base domain for all hosted services";
      };

      cloudflareTunnelCert = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Cert location for Cloudflare Tunnel";
      };

      cloudflareOriginCertPK = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Origin cert private key for Cloudflare Tunnel";
      };

      enableDirectIPHosting.enable = lib.mkEnableOption "Enables domain direct IP hosting";

      enableDirectIPHosting.email = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Email to be used with ACME";
      };

      ssl = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Path to SSL cert for domain";
      };

      sslKey = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Path to SSL private key for domain";
      };

      grafanaKey = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          A secret key for Grafana
          May be generated with "openssl rand -hex 32"
        '';
      };

      grafanaPort = lib.mkOption {
        type = lib.types.int;
        default = 5000;
        description = "The port to be used with grafana";
      };

      searxngPort = lib.mkOption {
        type = lib.types.int;
        default = 8888;
        description = "The port to be used with searxng";
      };

      forgejoPort = lib.mkOption {
        type = lib.types.int;
        default = 3000;
        description = "The port to be used with searxng";
      };
    };
  };
}
