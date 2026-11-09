{
  pkgs,
  config,
  username,
  ...
}:
let
  protonPkgs = config.packages.proton-Packages.packages;
  toolsDir = "/home/${username}/.config/heroic/tools/proton";
  paths = map (pkg: "${toolsDir}/${pkg.version}/files/bin/wine") protonPkgs;
in
{
  environment.systemPackages = [ pkgs.heroic ];

  home-manager.users.${username} = { lib, ... }: {
    xdg.configFile = lib.listToAttrs (
      map (
        pkg:
        lib.nameValuePair "heroic/tools/proton/${pkg.version}" {
          source = pkg.steamcompattool;
        }
      ) protonPkgs
    );

    home.activation.heroicWinePaths = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      cfg="$HOME/.config/heroic/config.json"
      if [ -f "$cfg" ] && ! ${pkgs.procps}/bin/pgrep -x heroic >/dev/null; then
        tmp="$(mktemp)"
        ${pkgs.jq}/bin/jq \
          --argjson paths '${builtins.toJSON paths}' \
          --arg prefix "$HOME/.config/heroic/tools/proton/" '
          .defaultSettings.customWinePaths = (
            ((.defaultSettings.customWinePaths // [])
              | map(select(startswith($prefix) | not)))
            + $paths | unique
          )
        ' "$cfg" > "$tmp" && mv "$tmp" "$cfg"
      fi
    '';
  };
}
