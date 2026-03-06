{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.drivers.nvidia;
in
{
  options.drivers.nvidia = {
    enable = mkEnableOption "Enable Nvidia Drivers";
  };

  config = mkIf cfg.enable {
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;

        #---------------------------------------------------------------------
        # Install additional packages that improve graphics performance and compatibility.
        #---------------------------------------------------------------------
        extraPackages = with pkgs; [
          intel-media-driver # LIBVA_DRIVER_NAME=iHD
          libvdpau
          libvdpau-va-gl
          vdpauinfo
          nvidia-vaapi-driver
          vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
          vaapiVdpau
          #vulkan-validation-layers
          libva
          libva-utils
        ];
      };

      nvidia = {
        # Modesetting is required.
        modesetting.enable = true;

        # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
        # Enable this if you have graphical corruption issues or application crashes after waking
        # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
        # of just the bare essentials.
        powerManagement.enable = true;

        # Fine-grained power management. Turns off GPU when not in use.
        # Experimental and only works on modern Nvidia GPUs (Turing or newer).
        powerManagement.finegrained = false;

        forceFullCompositionPipeline = true;

        #dynamicBoost.enable = true; # Dynamic Boost

        nvidiaPersistenced = lib.mkDefault false;

        # Use the NVidia open source kernel module (not to be confused with the
        # independent third-party "nouveau" open source driver).
        # Support is limited to the Turing and later architectures. Full list of
        # supported GPUs is at:
        # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
        # Only available from driver 515.43.04+
        # Currently alpha-quality/buggy, so false is currently the recommended setting.
        open = false;

        # Enable the Nvidia settings menu,
        # accessible via `nvidia-settings`.
        # accessible via `nvidia-settings`.

        # accessible via `nvidia-settings`.

        nvidiaSettings = true;

        package = config.boot.kernelPackages.nvidiaPackages.latest;

        # Optionally, you may need to select the appropriate driver version for your specific GPU.
        #package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        #  version = "555.58.02";
        #  sha256_64bit = "sha256-xctt4TPRlOJ6r5S54h5W6PT6/3Zy2R4ASNFPu8TSHKM=";
        #  sha256_aarch64 = "sha256-xctt4TPRlOJ6r5S54h5W6PT6/3Zy2R4ASNFPu8TSHKM=";
        #  openSha256 = "sha256-ZpuVZybW6CFN/gz9rx+UJvQ715FZnAOYfHn5jt5Z2C8=";
        #  settingsSha256 = "sha256-ZpuVZybW6CFN/gz9rx+UJvQ715FZnAOYfHn5jt5Z2C8=";
        #  persistencedSha256 = lib.fakeSha256;
        #};
      };

      nvidia-container-toolkit.enable = true;
    };
  };
}
