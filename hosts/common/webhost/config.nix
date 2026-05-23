{
  config,
  pkgs,
  ...
}:
let
  ssl = "/etc/ssl/ajhyperbit.dev/domain.cert.pem";
  sslKey = "/etc/ssl/ajhyperbit.dev/private.key.pem";
  proxyPass = ''
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
  '';
  domain = "ajhyperbit.dev";
in
{
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
          DOMAIN = "git.${domain}";
          HTTP_PORT = 3000;
          ROOT_URL = "https://git.${domain}/";
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

    nginx = {
      enable = true;
      virtualHosts = {
        # "${domain}" = {
        #   forceSSL = true;
        #   enableACME = true;
        #   sslCertificate = ssl;
        #   sslCertificateKey = sslKey;
        # };
        "grafana.${domain}" = {
          forceSSL = true;
          enableACME = true;
          sslCertificate = ssl;
          sslCertificateKey = sslKey;
          locations."/" = {
            proxyPass = "http://127.0.0.1:5000";
            proxyWebsockets = true;
            extraConfig = proxyPass;
          };
        };
        "search.${domain}" = {
          forceSSL = true;
          enableACME = true;
          sslCertificate = ssl;
          sslCertificateKey = sslKey;
          locations."/" = {
            proxyPass = "http://127.0.0.1:8888";
            proxyWebsockets = true;
            extraConfig = proxyPass;
          };
        };
        "git.${domain}" = {
          forceSSL = true;
          enableACME = true;
          sslCertificate = ssl;
          sslCertificateKey = sslKey;
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
          "interrupts"
          "tcpstat"
        ];
      };
    };

    grafana = {
      enable = true;
      settings = {
        server = {
          http_addr = "127.0.0.1";
          http_port = 5000;
          domain = "${domain}";
          root_url = "https://grafana.${domain}/";
        };
        security.secret_key = "SW2YcwTIb9zpOOhoPsMm";
      };
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = "ajhyperbit@gmail.com";
    };

    environment.systemPackages = with pkgs; [
      nginx
      forgejo
    ];

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
  };
}
