#Update flake.lock
nix flake update
#Add flake.lock to staged changes
git add flake.lock
#Handle if we're connected via SSH
if [[ -n "$SSH_TTY" ]]; then
export GPG_TTY=$(tty)
fi
#Commit the changes so that there isn't a "git tree dirty" warning
git commit -m "chore: update flake.lock"