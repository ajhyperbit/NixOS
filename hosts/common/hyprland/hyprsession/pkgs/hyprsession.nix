# pkgs/hyprsession.nix
{
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
}:
rustPlatform.buildRustPackage {
  pname = "hyprsession";
  version = "0.2.1-lua-dispatch";

  src = fetchFromGitHub {
    owner = "phedoreanu";
    repo = "hyprsession";
    rev = "3185fc59e8784aa74e4bc08a86348a4f889c88cb";
    hash = "sha256-s/4XLYtr4R92DvG6ffbwszGfCrdwHQjQDxjUN2oQ2NI";
  };

  cargoHash = "sha256-HRb6TNld8F8lIlOy7GqWasWe6Q1isZ1EYzLBCseVvR0";
  nativeBuildInputs = [ pkg-config ];

  meta.mainProgram = "hyprsession";
}
