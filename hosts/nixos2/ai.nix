{
  config,
  pkgs,
  options,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    clinfo
  ];

  nixpkgs.config.rocmSupport = true;

  services = {
    ollama = {
      enable = true;
      home = "/run/media/ajhyperbit/SATA_SSD/ollama";
      #Run without GPU
      #package = pkgs.ollama;
      #Run with GPU
      package = pkgs.ollama-rocm;
      user = "ollama";
      group = "users";
      rocmOverrideGfx = "12.0.1";
      #This graphics target is supported
      #So this option should not be needed
      syncModels = true;
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
        "translategemma:4b"
        "translategemma:12b"
      ];
    };
    open-webui = {
      enable = true;
      environment = {
        ANONYMIZED_TELEMETRY = "False";
        DO_NOT_TRACK = "True";
        SCARF_NO_ANALYTICS = "True";
        #WEBUI_AUTH = "False";
        #OLLAMA_VULKAN = "1";
      };
    };
  };

  users.users.ollama = {
    extraGroups = [
      "render"
    ];
  };

  # Temp fix for: "https://github.com/NixOS/nixpkgs/issues/487054"
  systemd.services.gfxrace = {
    before = [ "ollama.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.coreutils}/bin/sleep 10";
    };
    wantedBy = [ "multi-user.target" ];
    restartIfChanged = false;
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
