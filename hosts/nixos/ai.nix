{
  lib,
  username,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    clinfo
    rocmPackages.rocm-smi

    opencode
    opencode-desktop

    mcp-nixos
  ];

  nixpkgs.config.rocmSupport = true;

  services = {
    ollama = {
      enable = true;
      home = "/run/media/${username}/SATA_SSD/ollama";
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
        #newest to oldest
        "gemma4:26b" # April 2, 2026 
        "qwen3.5:9b" # February 16, 2026
        "devstral-small-2:24b" # December 9, 2025 
        "gpt-oss:20b" # August 5, 2025
        "qwen3-coder:30b" # July 2025 
      ];

      environmentVariables = {
        OLLAMA_CONTEXT_LENGTH = "32768";
        OLLAMA_FLASH_ATTENTION = "1";
        OLLAMA_KV_CACHE_TYPE = "q4_0";
      };
    };
    open-webui = {
      enable = true;
      environment = {
        ANONYMIZED_TELEMETRY = "False";
        DO_NOT_TRACK = "True";
        SCARF_NO_ANALYTICS = "True";
        #WEBUI_AUTH = "False";
        #OLLAMA_VULKAN = "1";
        ENABLE_SIGNUP = "False";
      };
      package = pkgs.open-webui;
    };
  };

  users.users.ollama = {
    extraGroups = [
      "render"
    ];
  };

  systemd = {
    services.ollama.serviceConfig.UMask = lib.mkForce "0022";
    tmpfiles.settings = {
      "ollamaConfig" = {
        "/run/media/${username}/SATA_SSD/ollama" = {
          d = {
            group = "users";
            mode = "0755";
            user = "ollama";
          };
        };
      };
    };
  };

  # systemd.tmpfiles.rules = [
  #   # Type Path                                  Mode UID    GID Age Argument
  #   "d     /run/media/ajhyperbit/SATA_SSD/ollama 0755 ollama 100 -   -"
  # ];

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
