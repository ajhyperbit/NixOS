{
  lib,
  username,
  pkgs,
  pkgs-d49b5ff,
  pkgs-sliding,
  ...
}:
let
  ollama_location = "/home/${username}/ollama";
in
{
  environment.systemPackages = with pkgs; [
    clinfo
  ];

  services = {
    ollama = {
      enable = true;
      home = ollama_location;
      package = pkgs-sliding.ollama;
      user = "ollama";
      group = "users";
      syncModels = true;
      loadModels = [
        #"mistral:7b"
        #"deepseek-r1:8b"
        "gpt-oss:20b"
        "gemma4:e2b"
        "gemma4:26b"
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
      package = pkgs-d49b5ff.open-webui;
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
        ollama_location = {
          d = {
            group = "users";
            mode = "0755";
            user = "ollama";
          };
        };
      };
    };
  };
}
