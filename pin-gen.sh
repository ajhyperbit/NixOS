#!/usr/bin/env bash

choose () {
    local default="$1"
    local prompt="$2"
    local answer

    read -p "$prompt" answer
    [ -z "$answer" ] && answer="$default"

    case "$answer" in
        [yY1] ) #printf "answered yes!\n"
            eval "git add 'Gen-$GEN.nix'"
			eval "git commit -m 'Pin generaton $GEN'"
            ;;
        [nN0] ) printf "Ok.\n"
            ;;
        [qQ]  ) printf "Exiting....\n"
            exit 1;
            ;;   
        *     ) printf "%b" "Unexpected answer '$answer'!\n" >&2
            exit 1;
            ;;
    esac
}

GEN=$1
DIR1=$2

if [ -z "$GEN" ]; then
  printf "Usage: $0 <generation> <directory>\n"
  printf "Generation: the generation's number you want to pin\n"
  printf "Directory: where you want the Gen-GEN#.nix file to go.\n"
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

conf=$(sudo tail -5 "/boot/loader/entries/nixos-generation-$GEN.conf")

cat << EOF > Gen-$GEN.nix
{ ... }:
{
  boot.loader.systemd-boot.extraEntries = {
    "00-Gen-$GEN.conf" = ''
		title Pinned NixOS Generation $GEN
		sort-key 00-pin-nixos
$(echo "$conf" | sed 's/^/    /')
    '';
  };
}
EOF

choose "n" "Do you want to git commit the created Gen-$GEN.nix file? [(Y)es/(N)o] (Default: No): "

exit 0

#Links with value or ideas worth considering:
#https://www.reddit.com/r/NixOS/comments/1n7sjmv/comment/ncaed7n/
#https://www.reddit.com/r/NixOS/comments/1n7sjmv/comment/nca7hyd/