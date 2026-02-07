# Users - NOTE: Packages defined on this will be on current user only
{
  pkgs,
  username,
  ...
}:
let
  inherit (import ./variables.nix) gitUsername;
in
{
  users = {
    users."${username}" = {
      homeMode = "755";
      isNormalUser = true;
      description = "${gitUsername}";
      extraGroups = [
        "networkmanager"
        "wheel"
        "libvirtd"
        "scanner"
        "lp"
        "video"
        "input"
        "audio"
      ];

      # define user packages here
      packages = with pkgs; [
      ];
    };

    defaultUserShell = pkgs.zsh;
  };

  environment.shells = with pkgs; [ zsh ];
  environment.systemPackages = with pkgs; [ fzf ];

  programs = {
    # Zsh configuration
    zsh = {
      enable = true;
      enableCompletion = true;
      ohMyZsh = {
        enable = true;
        #plugins = [ "git" ];
        theme = "xiong-chiamiov-plus";
      };

      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;

      promptInit = ''
        if [[ -n "$SSH_TTY" ]]; then
          fastfetch -c "$HOME/.config/fastfetch/config-compact-ssh.jsonc"
        else
          fastfetch -c "$HOME/.config/fastfetch/config-compact.jsonc"
        fi

        source <(fzf --zsh);
        HISTFILE=~/.zsh_history;
        HISTSIZE=10000;
        SAVEHIST=10000;
        setopt appendhistory;
      '';
    };
  };
}
