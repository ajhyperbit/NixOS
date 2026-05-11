# treefmt.nix
{ ... }:
{
  # Used to find the project root
  projectRootFile = "flake.nix";
  # Enable the terraform formatter
  programs = {
    deadnix.enable = true;
    nixfmt = {
      enable = true;
    };
    alejandra.enable = true;
  };
  settings.formatter.alejandra.priority = 1;
  settings.formatter.nixfmt.priority = 2;
}
