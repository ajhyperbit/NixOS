{
  inputs,
  config,
  ...
}:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
    ./config.nix
  ];

  sops.secrets = {
    grafanaKey = {
      owner = "grafana";
      restartUnits = [ "grafana.service" ];
    };

    cloudflareTunnelCert = {
      path = "/etc/cloudflared/693f4fee-c3a1-4133-ad4c-872e1031858c.json";
    };

    cloudflareOriginCertPK = {
      path = "/etc/ssl/ajhyperbit.dev/cloudflare-origin-pk.pem";
      owner = "nginx";
      restartUnits = [ "nginx.service" ];
    };
  };

  webhost = {
    enable = true;
    domain = "ajhyperbit.dev";
    grafanaKey = "${config.sops.secrets.grafanaKey.path}";
    cloudflareTunnelCert = "${config.sops.secrets.cloudflareTunnelCert.path}";
    cloudflareOriginCertPK = "${config.sops.secrets.cloudflareOriginCertPK.path}";

    domainSSH.enable = false;

    enableDirectIPHosting.enable = false;
    enableDirectIPHosting.email = "ajhyperbit@gmail.com";
  };
}
