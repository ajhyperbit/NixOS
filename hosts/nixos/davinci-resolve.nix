{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    davinci-resolve-studio
  ];
  environment.variables = {
    RUSTICL_ENABLE = "radeonsi";
  };
  hardware.graphics = {
    lib.mkMerge = {
      extraPackages = with pkgs; [
        mesa.opencl # Enables Rusticl (OpenCL) support
        rocmPackages.clr.icd
      ];
    };
  };
}
