# treefmt.nix
{ ... }:
{
  # Used to find the project root
  projectRootFile = "flake.nix";
  # Enable the terraform formatter
  programs = {
    deadnix.enable = true;
    nixfmt.enable = true;
    alejandra.enable = true;
    shellcheck.enable = true;
    shfmt.enable = true;
  };
  settings.formatter = {
    alejandra.priority = 1;
    nixfmt.priority = 2;
  };
}
