{
  inputs,
  self,
  host,
  system,
  username,
  cursor_size,
  cursor_theme,
  stateVersion-hm,
  ...
}:
{
  home-manager.useUserPackages = true;
  home-manager.users.ajhyperbit = {
    imports = [
      ./home.nix
      ../../hosts/${host}/home.nix
    ];
  };
  home-manager.extraSpecialArgs = {
    inherit
      inputs
      system
      self
      cursor_size
      cursor_theme
      username
      stateVersion-hm
      ;
  };
  home-manager.backupFileExtension = "backup";
}
