{
  pkgs,
  inputs,
  ...
}:
{
  programs = {
    hyprland = {
      #Worked to get v0.53.3 installed properly
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland.overrideAttrs (old: {
        postPatch = (old.postPatch or "") + ''
          sed -i 's/find_package(glaze 6\.0\.0 QUIET)/find_package(glaze QUIET)/' hyprpm/CMakeLists.txt
        '';
        buildInputs = (old.buildInputs or [ ]) ++ [
          pkgs.glaze
          pkgs.openssl
        ];
        cmakeFlags = (old.cmakeFlags or [ ]) ++ [
          "-Dglaze_DIR=${pkgs.glaze}/share/glaze"
        ];
        withSystemd = true;
      });
    };
  };
}
