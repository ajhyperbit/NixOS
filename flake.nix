{
  description = "AJ's NixOS configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-d49b5ff.url = "github:nixos/nixpkgs/d49b5ff8f46788770abcb732ac38bfa431ca5d5e";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "git+https://git.outfoxxed.me/quickshell/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    stylix.url = "github:danth/stylix";

    alejandra = {
      url = "github:kamadorueda/alejandra/4.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fw-fanctrl = {
      url = "github:TamtamHero/fw-fanctrl/packaging/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-alien.url = "github:thiagokokada/nix-alien";

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprlang.follows = "hyprland/hyprlang";
    };

    nix4vscode = {
      url = "github:nix-community/nix4vscode";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions/00e11463876a04a77fb97ba50c015ab9e5bee90d";
    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel/release";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lumen = {
      url = "github:jnsahaj/lumen";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-d49b5ff, # specific pinned nixpkgs version
      nixos-hardware, # hardware-specific modules
      nix-cachyos-kernel, # cachyos kernels
      home-manager, # home manager
      nix-index-database, # nix index db
      nix-alien, # package overlay/tool (never used as far as I remember)
      nix4vscode, # Declaritve VS code stuff
      nix-vscode-extensions, # More declaritve VS code stuff
      fw-fanctrl, # framework fan control
      stylix, # personal configuration overlay
      alejandra, # formatter
      disko, # disk management
      lumen, # diff viewer, commit message generator, and summerizer of changes using local LLM
      ...
    }:
    let
      system = "x86_64-linux"; # Remove later
      host = "nixos";
      laptop-host = "nixtop";
      nix-wsl = "nix-wsl";
      iso = "iso";
      nixserver = "nixserver";
      username = "ajhyperbit";
      home = "/home/ajhyperbit";
      cursor_size = 32;
      cursor_theme = "BreezeX-RosePine";

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
      pkgs-d49b5ff = import nixpkgs-d49b5ff {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
    in
    {
      nixosConfigurations = {
        #ANCHOR Main Desktop
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
            inherit pkgs-d49b5ff;
            inherit nix-cachyos-kernel;
          };
          modules = [
            ./hosts/${host}/config.nix
            ./hosts/${host}/ai.nix
            ./hosts/${host}/gpg-agent.nix
            ./hosts/${host}/drives.nix
            #./hosts/${host}/nixos/disko/disks.nix
            #./hosts/${host}/disko/wip-disks.nix
            ./hosts/${host}/input.nix
            ./hosts/${host}/${host}-hm.nix
            ./hosts/common/common.nix
            ./hosts/common/users.nix
            ./hosts/common/fonts.nix
            ./hosts/common/audio.nix
            ./hosts/common/desktop-entries/default-apps.nix
            ./hosts/common/startup.nix
            #./hosts/common/packages/ardunio.nix
            ./hosts/nixos/cachyos-kernel.nix
            ./hosts/common/temp-fixes.nix
            ./hosts/common/overlays.nix
            home-manager.nixosModules.home-manager
            nixos-hardware.nixosModules.common-cpu-amd
            nixos-hardware.nixosModules.common-cpu-amd-pstate
            nixos-hardware.nixosModules.common-cpu-amd-zenpower
            nixos-hardware.nixosModules.common-pc-ssd
            stylix.nixosModules.stylix
            disko.nixosModules.disko
            nix-index-database.nixosModules.nix-index

            {
              environment.systemPackages = [
                pkgs-d49b5ff.google-chrome
                #pkgs-d49b5ff.open-webui
              ];
            }

            (
              {
                self,
                system,
                ...
              }:
              {
                environment.systemPackages =
                  with self.inputs.nix-alien.packages.${pkgs.stdenv.hostPlatform.system}; [
                    nix-alien
                  ];
              }
            )
          ];
        };
        #Framework13
        "${laptop-host}" = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = {
            inherit system;
            inherit inputs;
            inherit username;
            inherit laptop-host;
            inherit home;
            inherit self;
          };
          modules = [
            ./hosts/${laptop-host}/config.nix
            ./hosts/${laptop-host}/hardware.nix
            ./hosts/common/common.nix
            ./hosts/common/users.nix
            nixos-hardware.nixosModules.framework-7040-amd
            home-manager.nixosModules.home-manager
            fw-fanctrl.nixosModules.default
            {
              home-manager.useUserPackages = true;
              home-manager.users.ajhyperbit = {
                imports = [
                  ./hosts/common/home.nix
                  ./hosts/${laptop-host}/home.nix
                ];
              };
              home-manager.extraSpecialArgs = {
                inherit inputs;
                inherit system;
                inherit self;
                inherit username;
              };
              home-manager.backupFileExtension = "backup";
            }
            stylix.nixosModules.stylix

            {
              environment.systemPackages = [ alejandra.defaultPackage.${pkgs.stdenv.hostPlatform.system} ];
            }
            (
              {
                self,
                system,
                ...
              }:
              {
                environment.systemPackages =
                  with self.inputs.nix-alien.packages.${pkgs.stdenv.hostPlatform.system}; [
                    nix-alien
                  ];
              }
            )
          ];
        };
        formatter =
          let
            pkg = nixpkgs.legacyPackages.${system}.nixfmt-rfc-style;
          in
          {
            x86_64-linux = pkg;
            x86_64-darwin = pkg;
            aarch64-darwin = pkg;
          };
      };
    };
}
