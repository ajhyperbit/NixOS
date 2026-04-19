{
  inputs,
  self,
  otg-host,
  system,
  username,
  cursor_size,
  cursor_theme,
  ...
}:
{
  home-manager.useUserPackages = true;
  home-manager.users.${username} = {
    imports = [
      ./home.nix
      ../../hosts/${otg-host}/home.nix
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
      ;
  };
  home-manager.backupFileExtension = "backup";
}
