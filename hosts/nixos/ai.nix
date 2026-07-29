{
  lib,
  pkgs,
  username,
  ...
}:
let
  ollamaModelConfigs = {
    # "devstral-small-2:24b" = {
    #   numCtx = 8192;
    #   output = 4096;
    #   name = "Devstral Small 2";
    #   roles = [
    #     "chat"
    #     "edit"
    #     "apply"
    #   ];
    # };
    # "gemma4:26b" = {
    #   numCtx = 8192;
    #   output = 4096;
    #   name = "Gemma 4 26b";
    #   roles = [
    #     "chat"
    #     "edit"
    #     "apply"
    #     "embed"
    #   ];
    # };
    # "gpt-oss:20b" = {
    #   numCtx = 32768;
    #   output = 8192;
    #   name = "GPT-OSS";
    #   roles = [
    #     "chat"
    #     "edit"
    #     "apply"
    #   ];
    # };
    # "qwen3-coder:30b" = {
    #   numCtx = 8192;
    #   output = 4096;
    #   name = "Qwen 3 Coder 30b";
    #   roles = [
    #     "chat"
    #     "edit"
    #     "apply"
    #   ];
    # };
    "qwen3.5:9b" = {
      numCtx = 131072;
      output = 16384;
      name = "Qwen 3.5 9b";
      roles = [
        "chat"
        "edit"
        "apply"
      ];
    };
  };

  maxContextLength = lib.foldl' lib.max 0 (
    map (cfg: cfg.numCtx) (builtins.attrValues ollamaModelConfigs)
  );

  continueConfig = {
    name = "Local Config";
    version = "1.0.0";
    schema = "v1";
    models = lib.mapAttrsToList (model: cfg: {
      name = cfg.name;
      provider = "ollama";
      inherit model;
      roles = cfg.roles;
      defaultCompletionOptions = {
        contextLength = cfg.numCtx;
      };
    }) ollamaModelConfigs;
  };

  mkModelfile =
    name: cfg:
    pkgs.writeText "Modelfile-${builtins.replaceStrings [ ":" ] [ "-" ] name}" ''
      FROM ${name}
      PARAMETER num_ctx ${toString cfg.numCtx}
    '';

  createModelsScript = pkgs.writeShellScript "ollama-create-models" ''
    until ollama list > /dev/null 2>&1; do
      echo "Waiting for ollama..."
      sleep 2
    done

    ${lib.concatStringsSep "\n" (
      lib.mapAttrsToList (name: cfg: ''
        echo "Applying modelfile for ${name}"
        ollama create "${name}" -f ${mkModelfile name cfg}
      '') ollamaModelConfigs
    )}
  '';
in
{
  sops.secrets = {
    openrouterKey_auth = {
      owner = "${username}";
      path = "/home/${username}/.local/share/opencode/auth.json";
    };
  };

  environment.systemPackages = with pkgs; [
    clinfo
    rocmPackages.rocm-smi

    opencode
    opencode-desktop

    lmstudio

    mcp-nixos
  ];

  nixpkgs.config.rocmSupport = true;

  services = {
    ollama = {
      enable = true;
      home = "/run/media/${username}/SATA_SSD/ollama";
      package = pkgs.ollama-rocm;
      user = "ollama";
      group = "users";
      rocmOverrideGfx = "12.0.1";
      syncModels = true;
      loadModels = lib.attrNames ollamaModelConfigs;
      environmentVariables = {
        OLLAMA_CONTEXT_LENGTH = toString maxContextLength;
        OLLAMA_FLASH_ATTENTION = "1";
        OLLAMA_KV_CACHE_TYPE = "q8_0";
      };
    };

    open-webui = {
      enable = false;
      environment = {
        ANONYMIZED_TELEMETRY = "False";
        DO_NOT_TRACK = "True";
        SCARF_NO_ANALYTICS = "True";
        ENABLE_SIGNUP = "False";
      };
      package = pkgs.open-webui;
    };
  };

  systemd.services.ollama-apply-modelfiles = {
    description = "Apply per-model Ollama parameter overrides";
    after = [ "ollama.service" ];
    requires = [ "ollama.service" ];
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.ollama-rocm ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = "ollama";
      ExecStart = createModelsScript;
    };
  };

  systemd.paths.ollama-modelfiles-watch = {
    description = "Watch for Ollama modelfile changes";
    wantedBy = [ "multi-user.target" ];
    pathConfig = {
      PathChanged = map (
        {
          name,
          value,
        }:
        "${mkModelfile name value}"
      ) (lib.attrsToList ollamaModelConfigs);
      Unit = "ollama-apply-modelfiles.service";
    };
  };

  users.users.ollama = {
    extraGroups = [ "render" ];
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

  hardware = {
    graphics = {
      extraPackages = with pkgs; [
        mesa.opencl
        rocmPackages.clr.icd
        rocmPackages.clr
      ];
    };
    amdgpu.opencl.enable = true;
  };

  home-manager.users.${username} = {
    xdg.configFile."opencode/opencode.jsonc".source =
      (pkgs.formats.json { }).generate "opencode.jsonc"
        {
          "$schema" = "https://opencode.ai/config.json";
          disabled_providers = [ ];
          provider = {
            ollama-local = {
              name = "Ollama";
              npm = "@ai-sdk/openai-compatible";
              options = {
                baseURL = "http://localhost:11434/v1";
              };
              models = lib.mapAttrs (_name: cfg: {
                name = cfg.name;
                limit = {
                  context = cfg.numCtx;
                  output = cfg.output;
                };
              }) ollamaModelConfigs;
            };
          };
        };

    home.file.".continue/config.yaml".source =
      (pkgs.formats.yaml { }).generate "config.yaml"
        continueConfig;
  };
}
