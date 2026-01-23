#Update flake.lock
nix flake update
#Add flake.lock to staged changes
git add flake.lock
#Commit the changes so that there isn't a "git tree dirty" warning
git commit -m "chore: update flake.lock"