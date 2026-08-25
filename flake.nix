{
  description = "AJ's NixOS configuration";

  inputs = {
    # Base inputs - no follows
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-26.05";
    nixpkgs-lib.url = "github:nix-community/nixpkgs.lib";
    nix-systems.url = "github:nix-systems/default";
    flake-compat = {
      url = "github:NixOS/flake-compat";
      flake = false;
    };

    # Flake utilities - follow base
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs-lib";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "nix-systems";
    };

    # NixOS infrastructure
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-topology = {
      url = "github:oddlama/nix-topology";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    #nix build .#topology

    # Kernel
    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel/release";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-parts.follows = "flake-parts";
    };

    # Hyprland ecosystem
    hyprland = {
      type = "github";
      owner = "hyprwm";
      repo = "Hyprland";
      # ref = "v0.56.1";
      # inputs.nixpkgs.follows = "nixpkgs";
      # inputs.pre-commit-hooks.inputs.flake-compat.follows = "flake-compat";
    };
    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
      inputs.hyprlang.follows = "hyprland/hyprlang";
    };

    # Wayland ecosystem
    quickshell = {
      url = "git+https://git.outfoxxed.me/quickshell/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctaliav4 = {
      url = "github:noctalia-dev/noctalia/legacy-v4";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.noctalia-qs.inputs.systems.follows = "nix-systems";
      inputs.noctalia-qs.inputs.treefmt-nix.follows = "treefmt-nix";
    };

    noctaliav5 = {
      url = "github:noctalia-dev/noctalia/cachix";
      #inputs.nixpkgs.follows = "nixpkgs";
    };

    # Theming
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.systems.follows = "nix-systems";
    };

    # Formatting / dev tools
    alejandra = {
      url = "github:kamadorueda/alejandra/4.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-index / alien
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.nix-index-database.follows = "nix-index-database";
    };

    # VSCode extensions
    nix4vscode = {
      url = "github:nix-community/nix4vscode";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "nix-systems";
    };
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions/00e11463876a04a77fb97ba50c015ab9e5bee90d";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixos-hardware, # hardware-specific modules
      nix-cachyos-kernel, # cachyos kernels
      home-manager, # home manager
      nix-index-database, # nix index db # package overlay/tool (never used as far as I remember) # Declaritve VS code stuff # More declaritve VS code stuff # framework fan control
      stylix, # personal configuration overlay
      disko, # disk management
      nix-systems,
      treefmt-nix,
      ...
    }:
    let
      host = "nixos";
      username = "ajhyperbit";
      home = "/home/${username}";
      cursor_size = 32;
      cursor_theme = "BreezeX-RosePine";
      # Formatter related
      eachSystem =
        f: nixpkgs.lib.genAttrs (import nix-systems) (system: f nixpkgs.legacyPackages.${system});
      treefmtEval = eachSystem (pkgs: treefmt-nix.lib.evalModule pkgs ./format/treefmt.nix);
    in
    {
      nixosConfigurations = {
        # Main Desktop
        "${host}" = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = {
            inherit system;
            inherit inputs;
            inherit username;
            inherit host;
            inherit home;
            inherit self;
            inherit cursor_size;
            inherit cursor_theme;
            inherit nix-cachyos-kernel;
          };
          modules = [
            #files
            ./sops/config.nix
            ./hosts/${host}/config.nix
            ./hosts/${host}/ai.nix
            ./hosts/${host}/gpg-agent.nix
            ./hosts/${host}/drives.nix
            #./hosts/${host}/disko/disks.nix
            ./hosts/${host}/input.nix
            ./hosts/${host}/audio.nix
            ./hosts/${host}/${host}-hm.nix
            ./hosts/${host}/cachyos-kernel.nix
            ./hosts/${host}/virtualization.nix
            ./hosts/common/common-module.nix
            ./hosts/common/packages/default.nix
            ./hosts/common/hyprland/noctalia/noctalia.nix
            ./hosts/common/users.nix
            ./hosts/common/fonts.nix
            ./hosts/common/audio.nix
            ./hosts/common/desktop-entries/default-apps.nix
            ./hosts/common/startup.nix
            ./hosts/common/temp-fixes.nix
            ./hosts/common/virtualization.nix
            ./hosts/common/security/security.nix
            ./hosts/common/nix-alien.nix
            ./hosts/common/webhost/default.nix

            #system modules
            home-manager.nixosModules.home-manager
            nixos-hardware.nixosModules.common-cpu-amd
            nixos-hardware.nixosModules.common-cpu-amd-pstate
            nixos-hardware.nixosModules.common-cpu-amd-zenpower
            nixos-hardware.nixosModules.common-pc-ssd
            stylix.nixosModules.stylix
            disko.nixosModules.disko
            nix-index-database.nixosModules.nix-index

            {
              nixpkgs.overlays = [ inputs.nix-topology.overlays.default ];
            }
            inputs.nix-topology.nixosModules.default

            {
              #User modules
              nixos.ai.enable = false;
            }
          ];
        };
      };
      formatter = eachSystem (pkgs: treefmtEval.${pkgs.stdenv.hostPlatform.system}.config.build.wrapper);
      # for `nix flake check`
      checks = eachSystem (pkgs: {
        formatting = treefmtEval.${pkgs.stdenv.hostPlatform.system}.config.build.check self;
      });

      packages = eachSystem (
        _pkgs:
        let
          pkgs = import nixpkgs {
            system = _pkgs.stdenv.hostPlatform.system;
            config.allowUnfree = true;
            overlays = [ inputs.nix-topology.overlays.default ];
          };
        in
        {
          topology =
            (import inputs.nix-topology {
              inherit pkgs;
              modules = [
                { nixosConfigurations = self.nixosConfigurations; }
              ];
            }).config.output;
        }
      );

      devShells = eachSystem (
        _pkgs:
        let
          pkgs = import nixpkgs {
            system = _pkgs.stdenv.hostPlatform.system;
            config.allowUnfree = true;
          };
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              python3Minimal
            ];
          };
        }
      );
    };
}
