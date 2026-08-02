{
  lib,
  pkgs,
  username,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    #Windows VM or Filesystem compatiblity
    qemu
    exfatprogs
    #Related to Virtualisation in settings
    dive # look into docker image layers
    podman-tui # status of containers in the terminal
    podman-desktop
    podman-compose # start group of containers for dev

    virt-manager
    virt-viewer
    spice
    spice-gtk

    looking-glass-client
    scream
  ];

  virtualisation = {
    libvirtd = {
      enable = true;

      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true; # Required for Windows 11 TPM support
        vhostUserPackages = with pkgs; [
          virtiofsd
        ];
      };
      #https://www.reddit.com/r/NixOS/comments/177wcyi/comment/k4vok4n
    };
    spiceUSBRedirection.enable = true;

    # Enable common container config files in /etc/containers
    containers = {
      enable = true;
    };
    #Podman https://nixos.wiki/wiki/Podman
    podman = {
      enable = true;
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      # Make the Podman socket available in place of the Docker socket, so Docker tools can find the Podman socket.
      dockerSocket.enable = true;
      # Make the Podman and Docker compatibility API available over the network with TLS client certificate authentication.
      #networkSocket.enable = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
    virtualbox = {
      host = {
        enable = lib.mkDefault false;
        addNetworkInterface = true;
        enableExtensionPack = true;
      };
      #guest.enable = true;
    };
  };

  programs.virt-manager.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "kvm"
      "qemu"
      "libvirtd"
      "vboxusers"
      "docker"
    ];
  };
}
