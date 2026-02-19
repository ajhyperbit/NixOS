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
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      stylix,
      alejandra,
      nixos-hardware,
      fw-fanctrl,
      nix-alien,
      disko,
      nix4vscode,
      nix-vscode-extensions,
      nixpkgs-d49b5ff,
      nix-index-database,
      ...
    }:
    let
      system = "x86_64-linux"; # Remove later
      host = "nixos";
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
        "nixos" = nixpkgs.lib.nixosSystem rec {
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
          };
          modules = [
            ./hosts/nixos/config.nix
            ./hosts/nixos/ai.nix
            ./hosts/nixos/gpg-agent.nix
            ./hosts/nixos/drives.nix
            #./hosts/nixos/nixos/disko/disks.nix
            #./hosts/nixos/disko/wip-disks.nix
            ./hosts/nixos/input.nix
            ./hosts/nixos/nixos-hm.nix
            ./hosts/common/common.nix
            ./hosts/common/users.nix
            ./hosts/common/fonts.nix
            ./hosts/common/audio.nix
            ./hosts/common/desktop-entries/default-apps.nix
            ./hosts/common/startup.nix
            #./hosts/common/packages/ardunio.nix
            ./hosts/pinned-gens/Gen-715.nix
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
                pkgs-d49b5ff.open-webui
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
        "nix2" = nixpkgs.lib.nixosSystem rec {
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
          };
          modules = [
            ./hosts/nixos2/config.nix
            ./hosts/nixos2/ai.nix
            ./hosts/nixos2/gpg-agent.nix
            ./hosts/nixos2/drives.nix
            #./hosts/nixos2/disko/disks.nix
            #./hosts/nixos2/disko/wip-disks.nix
            ./hosts/nixos2/disko/WD-Disk.nix
            ./hosts/nixos2/input.nix
            ./hosts/nixos2/nixos-hm.nix
            ./hosts/common/common.nix
            ./hosts/common/users.nix
            ./hosts/common/fonts.nix
            ./hosts/common/audio.nix
            ./hosts/common/desktop-entries/default-apps.nix
            ./hosts/common/startup.nix
            #./hosts/common/packages/ardunio.nix
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
                pkgs-d49b5ff.open-webui
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
        "nixtop" = nixpkgs.lib.nixosSystem rec {
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
            ./hosts/nixtop/config.nix
            ./hosts/nixtop/hardware.nix
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
                  ./hosts/nixtop/home.nix
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
