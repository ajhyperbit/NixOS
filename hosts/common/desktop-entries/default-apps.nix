{
  lib,
  config,
  ...
}:
let
  fileContent = builtins.readFile ./default-apps.list;

  lines = lib.strings.splitString "\n" fileContent;

  validLines = builtins.filter (
    line: line != "" && !(lib.strings.hasPrefix "[" line) && (lib.strings.hasInfix "=" line)
  ) lines;

  parseLine =
    line:
    let
      parts = lib.strings.splitString "=" line;
      mimeType = builtins.head parts;

      rawApp = lib.strings.concatStringsSep "=" (builtins.tail parts);
      cleanApp = lib.strings.removeSuffix ";" rawApp;
    in
    {
      name = mimeType;
      value = cleanApp;
    };

  parsedMimeApps = builtins.listToAttrs (builtins.map parseLine validLines);
in
{
  options = {
    default-apps.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = true;
    };
  };

  config = lib.mkIf config.default-apps.enable {
    xdg.mime.defaultApplications = parsedMimeApps // {
      "application/pdf" = "floorp.desktop";
      "inode/directory" = "thunar.desktop";
      "text/x-patch" = "kate.desktop";
    };
  };
}
