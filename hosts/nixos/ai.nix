{
  config,
  pkgs,
  options,
  ...
}: {
  environment.systemPackages = with pkgs; [
    clinfo
  ];

  nixpkgs.config.rocmSupport = true;

  services = {
    ollama = {
      enable = true;
      home = "/run/media/ajhyperbit/SATA_SSD/ollama";
      package = pkgs.ollama;
      user = "ollama";
      group = "users";
      #acceleration = "rocm";
      rocmOverrideGfx = "12.0.1";
      #This graphics target is supported
      #So this option should not be needed
      loadModels = [
        "mistral:7b"
        "deepseek-r1:8b"
        "gemma3:4b"
        "dolphin-llama3:8b"
        "qwen2.5:3b"
        "qwen2.5-coder:1.5b"
        "qwen2.5-coder:7B"
        "qwen3:8b"
        "llama3.2:3b"
        "nomic-embed-text:latest"
      ];
    };
    open-webui = {
      enable = true;
      environment = {
        ANONYMIZED_TELEMETRY = "False";
        DO_NOT_TRACK = "True";
        SCARF_NO_ANALYTICS = "True";
        WEBUI_AUTH = "False";
      };
    };
  };

  hardware = {
    graphics = {
      extraPackages = with pkgs; [
        mesa.opencl # Enables Rusticl (OpenCL) support
        rocmPackages.clr.icd
        rocmPackages.clr
      ];
    };
    amdgpu.opencl.enable = true;
  };
}
