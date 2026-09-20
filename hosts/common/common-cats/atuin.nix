{ ... }: {
  programs.atuin = {
    enable = true;
    flags = [
      "--disable-up-arrow"
    ];
    daemon.enable = false;
  };
  environment.etc."atuin/config.toml".text = "";
}
