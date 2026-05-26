#!/usr/bin/env bash

#Code block for choices
choose() {
  local default="$1"
  local prompt="$2"
  local answer
  local command="$3"

  # shellcheck disable=SC2162
  read -p "$prompt" answer
  [ -z "$answer" ] && answer="$default"

  case "$answer" in
  [yY1]) #printf "answered yes!\n"
    eval "$command"
    ;;
  [nN0])
    printf "Ok.\n"
    ;;
  [qQ])
    printf "Exiting....\n"
    exit 5
    ;;
  #REVIEW - Requires Testing
  #[sS]  ) printf "Running as sudo...\n"
  #    eval "sudo $command"
  #    ;;
  *)
    printf "%b" "Unexpected answer '$answer'!\n" >&2
    exit 3
    ;;
  esac
}

current_tag=$(nixos-rebuild list-generations | grep True | grep -Eo '[0-9]+' | head -1)

hostname=$(uname -n)

#Pulled from https://github.com/NixOS/nixpkgs/blob/66aa98b29099c636622a9d9c18370f13701716f6/pkgs/os-specific/linux/nixos-rebuild/nixos-rebuild.sh#L596
last_tag=$(git describe --tags --always)
hash=$(git rev-parse --short HEAD)

if [[ $(git status --short) != '' ]]; then
  dirty='-dirty'
fi

if [ "$last_tag" != "Gen-$hostname-$current_tag-$hash$dirty" ]; then
  # shellcheck disable=SC2086
  git tag Gen-$hostname-$current_tag-$hash$dirty

  printf "Last tag: %s\n" "$last_tag"

  # shellcheck disable=SC2027
  # shellcheck disable=SC2086
  choose "y" "Do you want to push the tag Gen-"${hostname}"-"${current_tag}"-"${hash}${dirty}"? [(Y)es/(N)o/(Q)uit] (Default: Yes): " "git push origin tag Gen-$hostname-$current_tag-$hash$dirty"
fi
