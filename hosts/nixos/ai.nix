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
        #"mistral:7b"
        #"deepseek-r1:8b"
        "gpt-oss:20b"
        "gemma4:e2b"
        "gemma4:26b"
        "qwen3-coder:30b"
        "qwen3-coder-next:q4_K_M"
        "devstral-small-2:24b"
        #"dolphin-llama3:8b"
        #"qwen2.5:3b"
        #"qwen2.5-coder:1.5b"
        #"qwen2.5-coder:3b"
        #"qwen2.5-coder:7B"
        #"qwen3:8b"
        #"llama3.2:3b"
        #"nomic-embed-text:latest"
        #"translategemma:4b"
        #"translategemma:12b"
        #"mevatron/diffsense:0.5b"
      ];

      environmentVariables = {
        OLLAMA_CONTEXT_LENGTH = "131072";
        OLLAMA_FLASH_ATTENTION = "1";
        OLLAMA_KV_CACHE_TYPE = "q8_0";
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
