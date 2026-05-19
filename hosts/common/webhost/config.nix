{
  config,
  pkgs,
  ...
}:
{
  # imports = [
  #   ./homer-settings.nix
  # ];

  services = {
    postgresql = {
      enable = true;
      ensureDatabases = [ "forgejo" ];
      ensureUsers = [
        {
          name = "forgejo";
          ensureDBOwnership = true;
        }
      ];
    };

    forgejo = {
      enable = true;
      database = {
        type = "postgres";
        user = "forgejo";
        name = "forgejo";
        socket = "/run/postgresql";
      };
      settings = {
        service.DISABLE_REGISTRATION = true;
        privacy.SHOW_USER_EMAIL = false;
        server = {
          DOMAIN = "git.ajhyperbit.dev";
          HTTP_PORT = 3000;
          ROOT_URL = "https://git.ajhyperbit.dev/";
        };
      };
    };

    ddns-updater = {
      enable = true;
      environment = {
        CONFIG_FILEPATH = "/home/ajhyperbit/private/porkbun/ddns-updater/config.json";
        DDNS_UPDATER_DATA_PATH = "/var/lib/ddns-updater";
      };
    };

    homer = {
      enable = true;
      virtualHost = {
        nginx.enable = false;
      };
    };

    nginx = {
      enable = true;
      virtualHosts = {
        "ajhyperbit.dev" = {
          forceSSL = true;
          sslCertificate = "/etc/ssl/ajhyperbit.dev/domain.cert.pem";
          sslCertificateKey = "/etc/ssl/ajhyperbit.dev/private.key.pem";
          locations."/" = {
            proxyPass = "http://127.0.0.1:5000";
            proxyWebsockets = true;
            extraConfig = ''
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
            '';
          };
        };
        "git.ajhyperbit.dev" = {
          forceSSL = true;
          sslCertificate = "/etc/ssl/ajhyperbit.dev/domain.cert.pem";
          sslCertificateKey = "/etc/ssl/ajhyperbit.dev/private.key.pem";
          locations."/" = {
            proxyPass = "http://127.0.0.1:3000";
            proxyWebsockets = true;
          };
        };
      };
    };

    prometheus = {
      enable = true;
      globalConfig.scrape_interval = "15s";
      scrapeConfigs = [
        {
          job_name = "node";
          static_configs = [
            {
              targets = [ "localhost:${toString config.services.prometheus.exporters.node.port}" ];
            }
          ];
        }
      ];
      exporters.node = {
        enable = true;
        enabledCollectors = [
          "systemd"
          "pressure"
        ];
      };
    };

    grafana = {
      enable = true;
      settings = {
        server = {
          http_addr = "127.0.0.1";
          http_port = 5000;
          domain = "ajhyperbit.dev";
          root_url = "https://ajhyperbit.dev/";
        };
        security.secret_key = "SW2YcwTIb9zpOOhoPsMm";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    nginx
    forgejo
  ];

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
