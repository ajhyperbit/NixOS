#!/usr/bin/env bash

## Usage
usage() {
	printf "Usage:\t %s <host> <rebuild method>\n\n" "$0"
	printf "host:\t Current valid host names are \"nixos\" or \"nixtop.\"\n"
	printf "rebuild method:\t Rebuild methods are either switch, boot, test, build, or dry-activate.\n"
	printf "Arguments put after the ones listed above will be used as arguments for nixos-rebuild command.\n\n"
	printf "More details on rebuild methods here: https://nixos.wiki/wiki/Nixos-rebuild\n"
}

if [ $# -eq 1 ]; then # if help requested
	if [ "$1" = "-h" ]; then
		usage
		exit 1
	fi
	if [ "$1" = "--help" ]; then
		usage
		exit 1
	fi
	printf "Don't recognize your option exiting...\n\n"
	usage
	exit 2
fi

host=${1:-}
reswitch=${2:-}
# Capture all arguments into a variable for use with nixos-rebuild
#args=${@:3}  # Capture arguments starting from the 3rd argument
user=$LOGNAME
#if [ -z "$user" ] then
#user=$(logname)
#fi
#LINK - https://unix.stackexchange.com/questions/479102/how-can-i-filter-read-only-file-systems-out-of-df-output#:~:text=df%20%2D%2Doutput%3Dpcent%2Ctarget%20%24(mount%20%2Dt%20ext4%20%7C%20grep%20rw%20%7C%20cut%20%2Dd%22%20%22%20%2Df1)
#storage=$(df --output=pcent,target $(mount -t ext4 | grep rw | cut -d" " -f1) | head -n -1)

if [ -z "$host" ] || [ -z "$reswitch" ]; then
	printf "Usage: %s <host> <rebuild method>\n" "$0"
	printf "  <host>: 'nixos' or 'nixtop'\n"
	printf "  <rebuild method>: 'switch', 'boot', 'test', or 'build'\n"
	printf "For more help, use -h or --help\n"
	exit 3
fi

path=$(pwd)

if [ "$path" != /home/"$user"/NixOS-Hyprland ]; then
	pushd ~/NixOS-Hyprland || exit
fi

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

choose "n" "Do you want to update flake.lock? [(Y)es/(N)o] (Default: No): " "source ~/NixOS-Hyprland/update-flake.sh"

printf "NixOS Rebuilding...\n"

# Rebuild, output simplified errors, log trackebacks
#sudo nixos-rebuild "$reswitch" --upgrade --show-trace --flake .#"$host" &>nixos-switch.log || (cat nixos-switch.log | grep --color error && exit 1) || grep -P -n "(?|(\/home\/"$user"\/NixOS-Hyprland\/([a-zA-Z]+)\.nix)|(hosts\/([a-zA-Z]+)\/([a-zA-Z]+).nix))" nixos-switch.log | sed 's/:[[:blank:]]*/: /'
set -o pipefail
if command -v nh >/dev/null 2>&1; then
	sudo -v
	nh os "$reswitch" -H "$host" |& tee nixos-switch.log
elif command -v nom >/dev/null 2>&1 && command -v unbuffer >/dev/null 2>&1; then
	sudo -v
	sudo unbuffer nixos-rebuild "$reswitch" --upgrade --show-trace --flake .#"$host" --log-format internal-json |& tee nixos-switch.log | nom --json
else
	sudo nix-shell -p nix-output-monitor.out expect.out --run "unbuffer nixos-rebuild $reswitch --upgrade --show-trace --flake .#$host --log-format internal-json |& nom --json"
	#Old command
	#sudo nixos-rebuild "$reswitch" --upgrade --show-trace --flake .#"$host" 2>&1 | tee nixos-switch.log
fi

#REVIEW - Testing required
#NOTE - If the above command doesn't function correctly, then the if statement below can replace it.
#if [ -z "args" ]; then
#sudo nixos-rebuild "$reswitch" --upgrade --show-trace --flake .#"$host" &>nixos-switch.log || (cat nixos-switch.log | grep --color error && exit 1) || grep -P -n "(?|(\/home\/"$user"\/NixOS-Hyprland\/([a-zA-Z]+)\.nix)|(hosts\/([a-zA-Z]+)\/([a-zA-Z]+).nix))" nixos-switch.log | sed 's/:[[:blank:]]*/: /'
#else
#sudo nixos-rebuild "$reswitch" --upgrade --show-trace --flake .#"$host" "$args" &>nixos-switch.log || (cat nixos-switch.log | grep --color error && exit 1) || grep -P -n "(?|(\/home\/"$user"\/NixOS-Hyprland\/([a-zA-Z]+)\.nix)|(hosts\/([a-zA-Z]+)\/([a-zA-Z]+).nix))" nixos-switch.log | sed 's/:[[:blank:]]*/: /'
#fi
#REVIEW - Testing required

current_tag=$(nixos-rebuild list-generations | grep True | grep -Eo '[0-9]+' | head -1)

hostname=$(uname -n)

#hash=$(git rev-parse --short HEAD) #Works to get the hash, but doesn't indicate if it is dirty

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
	choose "y" "Do you want to push the tag Gen-"${hostname}"-"${current_tag}"-"${hash}${dirty}"? [(Y)es/(N)o/(Q)uit] (Default: Yes): " "git push origin tag Gen-$host-$current_tag-$hash$dirty"
fi

#REVIEW - Testing required
#if ["$hostname" == "nixos"]; then
#printf "\n"%s"\n" "$storage"
#else
#:
#fi
#REVIEW - Testing required

#TODO: add a way to run nix-collect garbage with sudo?

#choose "n" "Do you want to run the nix garbage collector? [(Y)es/(S)udo/(N)o/(Q)uit] (Default: No): " "nix-collect-garbage -d &> nix-collect-garbage.log"

#choose "n" "Do you want to run the nix garbage collector? [(Y)es/(N)o/(Q)uit] (Default: No): " "nix-collect-garbage -d &> nix-collect-garbage.log"

#choose "n" "Do you want to trim generations? [(Y)es/(N)o/(Q)uit] (Default: No): " "source ~/NixOS-Hyprland/trim-generations.sh"

if [ "$path" != /home/"$user"/NixOS-Hyprland ]; then
	popd || exit
fi

exit 0
