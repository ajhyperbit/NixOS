{
  pkgs,
  config,
  username,
  ...
}:
let
  protonPkgs = config.packages.proton-Packages.packages;
  toolsDir = "/home/${username}/.config/heroic/tools/proton";

  # Local to this file; pkgs.proton-ge-bin is untouched everywhere else.
  heroicLatest = pkgs.proton-ge-bin.overrideAttrs {
    steamDisplayName = "GE-Proton-latest";
  };

  entries =
    (map (pkg: {
      name = pkg.version;
      inherit pkg;
    }) protonPkgs)
    ++ [
      {
        name = "GE-Proton-latest";
        pkg = heroicLatest;
      }
    ];

  paths = map (e: "${toolsDir}/${e.name}/proton") entries;
in
{
  environment.systemPackages = [ pkgs.heroic ];

  home-manager.users.${username} = { lib, ... }: {
    xdg.configFile = lib.listToAttrs (
      map (
        e:
        lib.nameValuePair "heroic/tools/proton/${e.name}" {
          source = e.pkg.steamcompattool;
        }
      ) entries
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
