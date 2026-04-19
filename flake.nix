{
  description = "AJ's NixOS configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-d49b5ff.url = "github:nixos/nixpkgs/d49b5ff8f46788770abcb732ac38bfa431ca5d5e";
    #Run this command to update this one specifically:
    #nix flake update nixpkgs-sliding-commit
    nixpkgs-sliding-commit.url = "nixpkgs/nixpkgs-unstable";

    flake-compat = {
      url = "github:NixOS/flake-compat";
      flake = false;
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs-lib";
    };

    nixpkgs-lib.url = "github:nix-community/nixpkgs.lib";

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

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    alejandra = {
      url = "github:kamadorueda/alejandra/4.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fw-fanctrl = {
      url = "github:TamtamHero/fw-fanctrl/packaging/nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
    };

    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
    };

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
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-parts.follows = "flake-parts";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-d49b5ff, # specific pinned nixpkgs version
      nixpkgs-sliding-commit,
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
      # lumen, # diff viewer, commit message generator, and summerizer of changes using local LLM
      ...
    }:
    let
      system = "x86_64-linux"; # Remove later
      host = "nixos";
      otg-host = "nixos-otg";
      username = "ajhyperbit";
      home = "/home/${username}";
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
      pkgs-sliding = import nixpkgs-sliding-commit {
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
            inherit pkgs-sliding;
            inherit nix-cachyos-kernel;
          };
          modules = [
            ./hosts/${host}/config.nix
            ./hosts/${host}/ai.nix
            ./hosts/${host}/gpg-agent.nix
            ./hosts/${host}/drives.nix
            #./hosts/${host}/disko/disks.nix
            ./hosts/${host}/input.nix
            ./hosts/${host}/audio.nix
            ./hosts/${host}/${host}-hm.nix
            ./hosts/${host}/cachyos-kernel.nix
            ./hosts/common/common.nix
            ./hosts/common/packages/packages.nix
            ./hosts/common/users.nix
            ./hosts/common/fonts.nix
            ./hosts/common/audio.nix
            ./hosts/common/desktop-entries/default-apps.nix
            ./hosts/common/startup.nix
            #./hosts/common/packages/ardunio.nix
            ./hosts/common/temp-fixes.nix
            # ./hosts/common/overlays.nix
            ./hosts/common/virtualization.nix
            home-manager.nixosModules.home-manager
            nixos-hardware.nixosModules.common-cpu-amd
            nixos-hardware.nixosModules.common-cpu-amd-pstate
            nixos-hardware.nixosModules.common-cpu-amd-zenpower
            nixos-hardware.nixosModules.common-pc-ssd
            stylix.nixosModules.stylix
            disko.nixosModules.disko
            nix-index-database.nixosModules.nix-index

            (
              {
                self,
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

        "${otg-host}" = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = {
            inherit system;
            inherit inputs;
            inherit username;
            inherit host;
            inherit otg-host;
            inherit home;
            inherit self;
            inherit cursor_size;
            inherit cursor_theme;
            inherit pkgs-d49b5ff;
            inherit pkgs-sliding;
            inherit nix-cachyos-kernel;
          };
          modules = [
            ./hosts/${otg-host}/config.nix
            ./hosts/${otg-host}/ai.nix
            ./hosts/${host}/gpg-agent.nix
            ./hosts/${otg-host}/drives.nix
            ./hosts/${otg-host}/disko/single-drive-setup.nix
            ./hosts/${host}/input.nix
            ./hosts/${otg-host}/${otg-host}-hm.nix
            ./hosts/${host}/cachyos-kernel.nix
            ./hosts/${otg-host}/sys-ver.nix
            ./hosts/common/common.nix
            ./hosts/common/packages/packages.nix
            ./hosts/common/users.nix
            ./hosts/common/fonts.nix
            ./hosts/common/audio.nix
            ./hosts/common/desktop-entries/default-apps.nix
            ./hosts/common/startup.nix
            #./hosts/common/packages/ardunio.nix
            ./hosts/common/temp-fixes.nix
            # ./hosts/common/overlays.nix
            ./hosts/common/virtualization.nix
            home-manager.nixosModules.home-manager
            nixos-hardware.nixosModules.common-pc-ssd
            stylix.nixosModules.stylix
            disko.nixosModules.disko
            nix-index-database.nixosModules.nix-index

            (
              {
                self,
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
        
        "${otg-host}-reduced" = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = {
            inherit system;
            inherit inputs;
            inherit username;
            inherit host;
            inherit otg-host;
            inherit home;
            inherit self;
            inherit cursor_size;
            inherit cursor_theme;
            inherit pkgs-d49b5ff;
            inherit pkgs-sliding;
            inherit nix-cachyos-kernel;
          };
          modules = [
            ./hosts/${otg-host}/config.nix
            #./hosts/${otg-host}/ai.nix
            ./hosts/${host}/gpg-agent.nix
            #./hosts/${otg-host}/drives.nix
            ./hosts/${otg-host}/disko/single-drive-setup.nix
            ./hosts/${host}/input.nix
            ./hosts/${otg-host}/${otg-host}-hm.nix
            ./hosts/${host}/cachyos-kernel.nix
            ./hosts/${otg-host}/sys-ver.nix
            #./hosts/common/common.nix
            #./hosts/common/packages/packages.nix
            ./hosts/common/users.nix
            #./hosts/common/fonts.nix
            ./hosts/common/audio.nix
            ./hosts/common/desktop-entries/default-apps.nix
            ./hosts/common/startup.nix
            #./hosts/common/packages/ardunio.nix
            ./hosts/common/temp-fixes.nix
            # ./hosts/common/overlays.nix
            ./hosts/common/virtualization.nix
            home-manager.nixosModules.home-manager
            nixos-hardware.nixosModules.common-pc-ssd
            stylix.nixosModules.stylix
            disko.nixosModules.disko
            nix-index-database.nixosModules.nix-index

            (
              {
                self,
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
