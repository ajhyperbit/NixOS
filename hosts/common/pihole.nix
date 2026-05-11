{ ... }:
{
  services = {
    pihole-web = {
      enable = true;
    };
    pihole-ftl = {
      enable = true;

      ### OPTIONS THAT NEED TO BE THOUGHT ABOUT, RESEARCHED, OR WORKED ON ###
      openFirewallDNS = false;
      openFirewallDHCP = false;
      openFirewallWebserver = false;
      queryLogDeleter = {
        enable = false;
      };
      settings = {
        #Configuration options for pihole.toml. See the upstream documentation.
        #TODO: Put toml config here
      };
      ########################################################################
      lists = {
        defaultList = {
          enabled = true;
          description = "Solid block list, comes default with pihole";
          url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
          type = "block";
        };

        OneHosts-Lite = {
          enabled = false;
          description = "1Hosts Lite - Reccomended for most uses by 1Hosts.";
          url = "https://o0.pages.dev/Lite/domains.txt";
          type = "block";
        };

        OneHosts-Pro = {
          enabled = true;
          description = "1Hosts Pro - More aggresive than lite (Been using this awhile, solid)";
          url = "https://o0.pages.dev/Pro/domains.txt";
          type = "block";
        };

        OneHosts-Xtra = {
          enabled = false;
          description = "1 Hosts Xtra - Most aggresive, (I haven't used this one, nor do I plan to)";
          url = "https://o0.pages.dev/Xtra/domains.txt";
          type = "block";
        };
      };
    };
  };
}
