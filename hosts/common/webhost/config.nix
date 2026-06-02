{
  lib,
  pkgs,
  config,
  ...
}:
let
  domain = config.webhost.domain;

  ssl =
    if config.webhost.ssl != null then
      config.webhost.ssl
    else
      "/etc/ssl/${config.webhost.domain}/domain.cert.pem";
  sslKey =
    if config.webhost.sslKey != null then
      config.webhost.sslKey
    else
      "/etc/ssl/${config.webhost.domain}/private.key.pem";

  sslAttrs = lib.mkIf config.webhost.enableDirectIPHosting.enable {
    forceSSL = true;
    enableACME = true;
    sslCertificate = ssl;
    sslCertificateKey = sslKey;
  };

  proxyPass = ''
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
  '';
  grafanaPortStr = builtins.toString config.webhost.grafanaPort;
  searxngPortStr = builtins.toString config.webhost.searxngPort;
  forgejoPortStr = builtins.toString config.webhost.forgejoPort;
in
{
  imports = [
    ./options.nix
  ];

  config = lib.mkIf config.webhost.enable {
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
            HTTP_PORT = config.webhost.forgejoPort;
            ROOT_URL = "https://git.${domain}/";
          };
        };
        lfs.enable = true;
      };

      ddns-updater = {
        enable = config.webhost.enableDirectIPHosting.enable;
        environment = {
          CONFIG_FILEPATH = "/home/ajhyperbit/private/porkbun/ddns-updater/config.json";
          DDNS_UPDATER_DATA_PATH = "/var/lib/ddns-updater";
        };
      };

      nginx = {
        enable = true;
        virtualHosts = {
          "${domain}" = sslAttrs // {
          };
          "grafana.${domain}" = sslAttrs // {
            locations."/" = {
              proxyPass = "http://127.0.0.1:${grafanaPortStr}";
              proxyWebsockets = true;
              extraConfig = proxyPass;
            };
          };
          "search.${domain}" = sslAttrs // {
            locations."/" = {
              proxyPass = "http://127.0.0.1:${searxngPortStr}";
              proxyWebsockets = true;
              extraConfig = proxyPass;
            };
          };
          "git.${domain}" = sslAttrs // {
            locations."/" = {
              proxyPass = "http://127.0.0.1:${forgejoPortStr}";
              proxyWebsockets = true;
              extraConfig = proxyPass;
            };
          };
        };
      };

      prometheus = {
        enable = true;
        globalConfig.scrape_interval = "5s";
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
            http_port = config.webhost.grafanaPort;
            domain = "${domain}";
            root_url = "https://grafana.${domain}/";
          };
          security.secret_key = "$__file{${config.webhost.grafanaKey}}";
        };
      };

      # fail2ban = {
      #   enable = true;
      #   maxretry = 5;
      #   bantime = "1h";
      #   jails = {
      #     nginx-botsearch = ''
      #       enabled   = true
      #       port      = http,https
      #       filter    = nginx-botsearch
      #       logpath   = /var/log/nginx/access.log
      #       maxretry  = 5
      #     '';
      #   };
      # };

      cloudflared = {
        enable = true;
        tunnels = {
          "693f4fee-c3a1-4133-ad4c-872e1031858c" = {
            credentialsFile = "${config.webhost.cloudflareTunnelCert}";
            certificateFile = "${config.webhost.cloudflareOriginCertPK}";
            ingress = {
              "grafana.${domain}" = "http://localhost:${grafanaPortStr}";
              "search.${domain}" = "http://localhost:${searxngPortStr}";
              "git.${domain}" = "http://localhost:${forgejoPortStr}";
            };
            default = "http_status:404";
          };
        };
      };
    };

    #enable to debug cloudflared tunnel
    # systemd.services."cloudflared-tunnel-693f4fee-c3a1-4133-ad4c-872e1031858c" = {
    #   environment = {
    #     TUNNEL_LOGLEVEL = "debug";
    #   };
    # };

    security.acme = {
      acceptTerms = lib.mkIf config.webhost.enableDirectIPHosting.enable true;
      defaults.email = "${config.webhost.enableDirectIPHosting.email}";
    };

    environment.systemPackages = with pkgs; [
      nginx
      forgejo
      cloudflared
    ];

    networking.firewall.allowedTCPPorts = [
      22
      80
      443
    ];
  };
}
