{
  inputs,
  pkgs,
  ...
}:
#let
#  python-packages = pkgs.python3.withPackages (
#    ps: with ps; [
#      requests
#      pyquery # needed for hyprland-dots Weather script
#    ]
#  );
#in
{
  imports = [
    ./package-overlays/proton-ge-overlays/proton-ge-overlay.nix
  ];

  environment.systemPackages = with pkgs; [
    lsof
    neovim
    nano
    strace
    wget
    curl
    psmisc
    socat
    #google-chrome
    chromium
    # System Packages
    #baobab # Disk usage analyzer
    btrfs-progs
    duf
    eza
    ffmpeg
    glib # for gsettings to work
    gsettings-qt
    libappindicator
    openssl # required by Rainbow borders
    xdg-user-dirs
    xdg-utils
    xdg-desktop-portal-gtk
    fastfetch
    (mpv.override { scripts = [ mpvScripts.mpris ]; }) # with tray

    #Games
    #gamescope
    mangohud
    rare
    discord
    (discord.override {
      # remove any overrides that you don't want
      withOpenASAR = true;
      withVencord = true;
    })
    vesktop
    wine
    wine64
    wine-staging
    wine-wayland
    winetricks
    protontricks
    (bottles.override { removeWarningPopup = true; })
    gsmartcontrol

    #System tools
    parted
    gparted
    putty
    htop
    remmina
    ethtool
    hwinfo
    wireshark
    vlc
    mpv
    pciutils
    kdePackages.kate
    fastfetch
    ghfetch
    screenfetch
    cpufetch
    ramfetch
    disfetch
    #nix-index
    fetchutils
    #Manage Files as admin
    kdePackages.kio-admin
    kdePackages.ark
    lm_sensors
    netdata
    lshw
    impression
    #Printing
    #cups-filters
    #cups-printers
    #canon-cups-ufr2
    #cups-bjnp

    #Torrenting
    #qbittorrent
    #miru #Streaming torrents

    #Vulkan
    vulkan-loader
    vulkan-validation-layers
    vulkan-tools

    #Productivity / Video things
    (wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-pipewire-audio-capture
        obs-vkcapture
        obs-multi-rtmp
        obs-source-clone
        obs-source-record
        obs-source-switcher
        obs-websocket
        waveform
        obs-vaapi
        obs-teleport
        obs-scale-to-sound
        obs-move-transition
        obs-command-source
        input-overlay
        obs-composite-blur
      ];
    })

    #handbrake

    #Coding
    gitFull
    gh
    vscode-fhs
    inputs.alejandra.defaultPackage.${stdenv.hostPlatform.system}
    direnv
    #python3Full
    #python312Packages.pip
    virtualenv
    #obsidian
    libei
    libportal
    #Twitch
    #chatterino2  #Chatterino without 7tv stuff
    #chatterino7 #Chatterino with 7tv stuff

    #Misc
    spotify
    tailscale
    jq
    qdirstat
    service-wrapper
    ntfs3g # FUSE-based NTFS driver with full write support
    nvd # Nix/NixOS package version diff tool
    #p7zip            #
    #rpi-imager # Raspberry Pi Imaging Utility

    dmidecode # System BIOS checker

    furmark

    #School
    #onedrivegui
    libreoffice
    hunspell
    hunspellDicts.en_US
    hunspellDicts.en-us

    # Hyprland Stuff
    #ags #V2 ags was released
    #ags_1
    brightnessctl # for brightness control
    cava
    eog
    gtk-engine-murrine # for gtk themes
    hypridle # requires unstable channel
    imagemagick
    inxi
    libsForQt5.qtstyleplugin-kvantum # kvantum
    nwg-look # requires unstable channel
    #nvtopPackages.full
    pamixer
    pavucontrol
    playerctl
    pyprland
    qt6Packages.qt6ct
    qt6.qtwayland
    qt6Packages.qtstyleplugin-kvantum # kvantum
    swappy
    unzip
    wallust
    wlogout
    yad
    yt-dlp
    greetd
    tuigreet

    (pkgs.hyprland.override {
      # or inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland
      #enableXWayland = true;  # whether to enable XWayland
      #legacyRenderer = false; # whether to use the legacy renderer (for old GPUs)
      withSystemd = true; # whether to build with systemd support
    })

    #Hyperland  #https://www.youtube.com/watch?v=61wGzIv12Ds
    xlsclients # Check if running with xwayland
    #Terminals
    kitty
    #Alternatives
    #alacritty
    #wezterm

    #Screenshots
    hyprshot
    grim
    slurp
    wl-clipboard

    meson
    waybar
    (pkgs.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    }))
    #eww
    dunst
    #mako
    libnotify
    swaynotificationcenter
    networkmanagerapplet
    #Wallpaper Daemons
    #hyprpaper
    #swaybg
    #wpaperd
    #mpvpaper
    swww
    #App Launcher
    #most popular
    rofi
    #gtk rofi
    #wofi
    #Wiki also suggests
    bemenu
    #fuzzel
    #tofi

    #Polkit agent
    polkit
    hyprpolkitagent

    hyprcursor # requires unstable channel

    #Bluetooth
    overskride

    #Libraries
    libsecret
    egl-wayland

    dialog # makes certain things work within terminal

    #busybox
    traceroute

    #ventoy-full

    nixos-generators

    filezilla

    zoom-us

    virt-manager
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    #virtio-win
    #win-spice
    #adwaita-icon-theme

    cyberchef # Cyber Swiss Army Knife for encryption, encoding, compression and data analysis

    streamlink # Pipe Twtich into something like VLC

    file-roller # Appears to have better compatibility with more zip file types.

    gomtree # File system validation

    meld # Visual diff and merge tool

    quickemu # Quickly create and run optimized virtual machines

    testdisk # Data recovery utilities

    nixfmt # Official formatter for Nix code
    shfmt # Shell script formatter

    disko # Declarative disk partitioning and formatting using nix

    ddrescue

    pulseaudio

    android-tools

    phoronix-test-suite

    font-manager
    fontforge

    #virtualbox

    bun

    #Nintendo Switch stuff
    #ryujinx
    ryubing
    fusee-nano

    #archiver stuff
    _7zz
    _7zz-rar
    rar
    unar
    arj
    commons-compress

    rose-pine-cursor
    inputs.rose-pine-hyprcursor.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default
    hyprland-qt-support
    qt6.qt5compat
    qt6.qtbase
    qt6.qtquick3d
    qt6.qtwayland
    qt6.qtdeclarative
    qt6.qtsvg

    dysk

    vscodium-fhs

    xwayland-satellite

    #Possible fix for some cursor weirdness within wayland
    xsettingsd
    xrdb

    #Mouse customization stuff
    libratbag
    piper

    usbimager
    usbutils

    #Editing
    #kdePackages.kdenlive

    limo

    ydotool

    vintagestory

    nix-output-monitor
    expect

    procps

    rpcs3
    #For HDMI-CEC devices
    libcec
    v4l-utils

    mesa-demos

    chafa

    theclicker

    bubblewrap
  ];
  #    ++ [
  #      python-packages
  #    ];
}
