#!/bin/bash
#Update flake.lock
nix flake update
#Update everything aside from hyprland
#nix flake update nixpkgs nixpkgs-d49b5ff nixpkgs-sliding-commit flake-compact flake-parts nixpkgs-lib nix-index-database home-manager quickshell nixos-hardware stylix alejandra fw-fanctrl nix-alien disko rose-pine-hyprcursor nix4vscode nix-vscode-extensions nix-cachyos-kernel
#Add flake.lock to staged changes
git add flake.lock
#Handle if we're connected via SSH
if [[ -n $SSH_TTY ]]; then
  # shellcheck disable=SC2155
  export GPG_TTY=$(tty)
fi
#Commit the changes so that there isn't a "git tree dirty" warning
git commit -m "chore: update flake.lock"
