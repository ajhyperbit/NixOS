{
  pkgs,
  ...
}:
{
  environment.systemPackages =
    (with pkgs; [
      arduino
      arduino-core
      arduino-cli
      #arduino-mk
      #arduino-ide
    ]);
}
