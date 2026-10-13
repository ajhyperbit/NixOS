#!/usr/bin/env bash
msg="chore: update flake.lock"

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

#Nothing changed, nothing to commit
if git diff --cached --quiet; then
  printf "flake.lock unchanged, nothing to commit.\n"
  return 0 2>/dev/null || exit 0
fi

#Amend if HEAD is an unpushed update commit and only flake.lock is staged
amend=false
if [ "$(git log -1 --format=%s HEAD)" = "$msg" ] &&
  [ "$(git diff --cached --name-only)" = "flake.lock" ] &&
  [ -z "$(git branch -r --contains HEAD 2>/dev/null)" ]; then
  amend=true
fi

#Commit the changes so that there isn't a "git tree dirty" warning
if $amend; then
  printf "Previous update commit is unpushed, amending it.\n"
  git commit --amend --no-edit
else
  git commit -m "$msg"
fi
