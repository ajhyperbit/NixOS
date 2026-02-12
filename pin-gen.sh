#!/usr/bin/env bash

GEN=$1
DIR1=$2

if [ -z "$GEN" ]; then
  printf "Usage: $0 <generation> <directory (optional)>\n"
  exit 1
fi

if [ -z "$DIR1" ]; then
  DIR1=~/NixOS-Hyprland/hosts/pinned-gens
fi

STORE=$(readlink -f "/nix/var/nix/profiles/system-$GEN-link")

if [ ! -e "$STORE" ]; then
  printf "Error: Generation link not found: /nix/var/nix/profiles/system-$GEN-link\n"
  exit 1
fi

sudo mkdir -p "/nix/var/nix/gcroots/manual"

DIR2="/nix/var/nix/gcroots/manual/Gen-$GEN"

if [ -e "$DIR2" ]; then
	printf "Directory already exists\n"
else
	sudo ln -s "$STORE" "/nix/var/nix/gcroots/manual/Gen-$GEN"
	printf "Symlink created: /nix/var/nix/gcroots/manual/Gen-$GEN -> $STORE\n"
fi

mkdir -p "$DIR1"

path=$(pwd)

if [ $path != $DIR1 ]; then
	pushd $DIR1
fi

conf=$(sudo tail -6 "/boot/loader/entries/nixos-generation-$GEN.conf")

cat << EOF > Gen-$GEN.nix
{ ... }:
{
  boot.loader.systemd-boot.extraEntries = {
    "00-Gen-$GEN.conf" = ''
    title NixOS Gen-$GEN
$(echo "$conf" | sed 's/^/    /')
    '';
  };
}
EOF

exit 0