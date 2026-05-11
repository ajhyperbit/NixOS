# treefmt.nix
{ ... }:
{
  # Used to find the project root
  projectRootFile = "flake.nix";
  # Enable the terraform formatter
  programs = {
    deadnix.enable = true;
    alejandra.enable = true;
    nixfmt.enable = true;
  };
}
