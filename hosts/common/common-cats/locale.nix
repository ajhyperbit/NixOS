# Locale and timezone configuration
{
  lib,
  config,
  ...
}:
{
  options = {
    common.locale.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = true;
    };
  };

  config = lib.mkIf config.common.locale.enable {
    # Set your time zone.
    time.timeZone = "America/Chicago";

    #lib.mkMerge = {i18n.supportedLocales = ["all"];};

    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
      };
    };

    environment.plasma6.excludePackages = [
      #plasma-browser-integration
      #khelpcenter
      #spectacle
    ];
  };
}
