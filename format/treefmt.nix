# treefmt.nix
{ ... }: {
  # Used to find the project root
  projectRootFile = "flake.nix";
  # Enable the formatters
  programs = {
    deadnix.enable = true;
    nixfmt.enable = true;
    alejandra.enable = true;
    shellcheck.enable = true;
    shfmt.enable = true;
  };
  # Formatting settings
  settings.formatter = {
    alejandra.priority = 1;
    nixfmt.priority = 2;
  };
}
