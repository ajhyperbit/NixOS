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
    ./plasma.nix
    ./package-overlays/proton-ge-overlays/proton-ge-overlay.nix
  ];

  environment = {
    systemPackages = with pkgs; [
      # ── System Info, Hardware & Monitoring ────────────────────────────────────
      htop # Interactive process viewer
      netdata # Real-time system and application performance monitoring
      fastfetch # Fast system info fetcher (neofetch alternative)
      ghfetch # GitHub-style system info fetch
      screenfetch # Classic system info fetch for screenshots
      cpufetch # CPU-focused system info fetcher
      ramfetch # RAM-focused system info fetcher
      disfetch # Discord-style system info fetcher
      fetchutils # Collection of fetch utilities
      dmidecode # Read hardware info from BIOS/UEFI (SMBIOS/DMI)
      hwinfo # Detailed hardware configuration and probe tool
      pciutils # PCI bus utilities (lspci, setpci)
      usbutils # USB utilities (lsusb)
      i2c-tools # I2C bus probing and access utilities
      lm_sensors # Read hardware sensors (CPU temp, fan speeds, voltages)
      lshw # Detailed hardware configuration lister
      mesa-demos # Mesa OpenGL demo and benchmark programs
      furmark # GPU stress test and OpenGL/Vulkan benchmark
      phoronix-test-suite # Comprehensive cross-platform hardware benchmarking suite

      # ── Disk & Storage ────────────────────────────────────────────────────────
      btrfs-progs # Btrfs filesystem utilities (balance, scrub, snapshot, etc.)
      parted # Command-line disk partition manipulation
      gparted # GTK GUI disk partition editor
      gsmartcontrol # GUI for SMART disk health data inspection
      qdirstat # Qt-based disk usage analyzer (like WinDirStat)
      ntfs3g # FUSE-based NTFS driver with full read/write support
      ddrescue # Data recovery tool for damaged or failing drives
      testdisk # Partition and file recovery utility
      disko # Declarative disk partitioning and formatting using nix
      gomtree # File system tree validation against recorded manifests

      # ── Networking & Remote Access ────────────────────────────────────────────
      tailscale # WireGuard-based mesh VPN
      filezilla # Cross-platform FTP, FTPS, and SFTP client
      putty # SSH and serial terminal emulator
      remmina # Remote desktop client supporting RDP, VNC, and SSH

      # ── Virtualization & Sandboxing ───────────────────────────────────────────
      virt-manager # GUI for managing QEMU/KVM virtual machines
      virt-viewer # Lightweight viewer for virtual machine displays
      spice # SPICE remote display protocol support
      spice-gtk # GTK client widget for SPICE connections
      spice-protocol # SPICE protocol headers and definitions
      quickemu # Quickly create and run optimized QEMU virtual machines
      bubblewrap # Unprivileged sandboxing and lightweight container tool

      # ── Browsers ──────────────────────────────────────────────────────────────
      google-chrome # Google Chrome browser
      chromium # Open-source Chromium browser
      floorp-bin # Firefox-based privacy-focused browser
      firefox-devedition # Firefox Developer Edition with devtools

      # ── Gaming & Emulation ────────────────────────────────────────────────────
      mangohud # Vulkan/OpenGL overlay for FPS, CPU/GPU usage, and temps
      rare # Epic Games Store launcher GUI for Linux
      rpcs3 # PlayStation 3 emulator
      ryubing # Nintendo Switch emulator (Ryujinx community fork)
      fusee-nano # Fusée Gelée payload injector for Nintendo Switch hacking
      theclicker # Auto-clicker

      # ── Wine & Compatibility Layer ────────────────────────────────────────────
      wine # Windows compatibility layer (32-bit)
      wine64 # Windows compatibility layer (64-bit)
      wine-staging # Wine with staging patches for improved game compatibility
      wine-wayland # Wine with native Wayland driver support
      winetricks # Install Windows libraries and components into Wine prefixes
      protontricks # Winetricks wrapper for Steam/Proton prefixes
      (bottles.override {
        # Wine prefix manager with per-application profiles
        removeWarningPopup = true;
      })

      # ── Communication ─────────────────────────────────────────────────────────
      (discord.override {
        # Discord with OpenASAR performance patches and Vencord mods
        withOpenASAR = true;
      })
      vesktop # Alternate Discord client with Vencord built in
      zoom-us # Zoom video conferencing client

      # ── Audio & Video ─────────────────────────────────────────────────────────
      ffmpeg # Comprehensive multimedia transcoding and processing toolkit
      (mpv.override {
        # Media player with MPRIS support for media keys and tray
        scripts = [ mpvScripts.mpris ];
      })
      vlc # Versatile media player supporting many formats
      pavucontrol # PulseAudio/PipeWire volume control GUI
      pamixer # PulseAudio/PipeWire CLI mixer
      playerctl # MPRIS media player controller for scripts and keybinds
      pulseaudio # PulseAudio CLI utilities (pactl, pacmd, etc.)
      cava # Console-based audio visualizer
      streamlink # Pipe Twitch and other streams into a local player
      yt-dlp # YouTube and multi-site video/audio downloader
      v4l-utils # Video4Linux2 utilities for webcams and capture cards
      libcec # HDMI-CEC device control library and utilities

      # ── OBS Studio ────────────────────────────────────────────────────────────
      (wrapOBS {
        plugins = with pkgs.obs-studio-plugins; [
          wlrobs # wlroots-based screen capture source
          obs-pipewire-audio-capture # PipeWire application audio capture source
          obs-vkcapture # Vulkan/OpenGL game capture via injection
          obs-multi-rtmp # Stream simultaneously to multiple RTMP endpoints
          obs-source-clone # Clone and reuse existing OBS sources
          obs-source-record # Record individual sources to separate output files
          obs-source-switcher # Switch between sources on a timer or hotkey
          obs-websocket # WebSocket API for remote OBS control
          waveform # Audio waveform visualization source
          obs-vaapi # VAAPI hardware-accelerated video encoding
          obs-teleport # Low-latency LAN source sharing (NDI-style)
          obs-scale-to-sound # Scale a source dynamically based on audio level
          obs-move-transition # Smooth animated move transition between scenes
          obs-command-source # Execute shell commands triggered by OBS scenes
          input-overlay # Display keyboard, mouse, and gamepad input on stream
          obs-composite-blur # Composite blur filter for sources and scenes
        ];
      })

      # ── Screenshots & Clipboard ───────────────────────────────────────────────
      hyprshot # Screenshot utility for Hyprland
      grim # Wayland screenshot capture tool
      slurp # Interactive region selector for Wayland compositors
      wl-clipboard # Wayland clipboard utilities (wl-copy, wl-paste)
      swappy # Wayland screenshot annotation and editing tool

      # ── Hyprland & Wayland Shell ──────────────────────────────────────────────
      (pkgs.waybar.overrideAttrs (oldAttrs: {
        # Wayland status bar with experimental modules enabled
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      }))
      dunst # Lightweight notification daemon
      swaynotificationcenter # Notification center panel for Sway/Hyprland
      libnotify # Library and CLI for sending desktop notifications
      networkmanagerapplet # NetworkManager system tray applet
      awww # Animated wallpaper daemon for Wayland
      rofi # Application launcher and window switcher
      bemenu # Dynamic Wayland-native menu (dmenu alternative)
      pyprland # Python-based plugin host for Hyprland extensions
      hypridle # Idle management daemon for Hyprland (lock/DPMS)
      hyprcursor # Cursor theme engine for Hyprland
      hyprpolkitagent # Polkit authentication agent for Hyprland
      wlogout # Wayland logout and session action menu
      wallust # Generate color schemes from wallpapers
      yad # Yet Another Dialog — GTK dialog builder for shell scripts
      tuigreet # TUI greeter for the greetd display manager
      xwayland-satellite # Rootless XWayland bridge for Wayland compositors
      xlsclients # List X11 clients (identify what is running via XWayland)
      xsettingsd # Lightweight XSETTINGS daemon for cursor/theme propagation
      xrdb # X resource database manager
      nwg-look # GTK settings editor for wlroots-based compositors
      brightnessctl # Read and control display/backlight brightness
      imagemagick # Image manipulation and conversion CLI toolkit

      # ── Themes, Fonts & Appearance ────────────────────────────────────────────
      gtk-engine-murrine # GTK2 Murrine engine (required by some legacy GTK themes)
      libsForQt5.qtstyleplugin-kvantum # Kvantum SVG-based theme engine for Qt5
      qt6Packages.qtstyleplugin-kvantum # Kvantum SVG-based theme engine for Qt6
      nwg-look # GTK3/4 appearance configuration tool for wlroots compositors
      font-manager # GUI font manager and viewer
      fontforge # Font editor and format conversion tool
      rose-pine-cursor # Rosé Pine cursor theme (X11/Wayland)
      inputs.rose-pine-hyprcursor.packages.${pkgs.stdenv.hostPlatform.system}.default # Rosé Pine cursor theme for Hyprland

      # ── Qt Libraries ──────────────────────────────────────────────────────────
      gsettings-qt # GSettings bindings for Qt applications
      qt6Packages.qt6ct # Qt6 appearance and style configuration tool
      qt6.qt5compat # Qt5 compatibility layer for Qt6 applications
      qt6.qtbase # Qt6 base module
      qt6.qtquick3d # Qt6 Quick 3D rendering module
      qt6.qtwayland # Qt6 Wayland platform integration
      qt6.qtdeclarative # Qt6 QML and Qt Quick module
      qt6.qtsvg # Qt6 SVG rendering module
      inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default # Scriptable Wayland shell component toolkit

      # ── File Management & Archives ────────────────────────────────────────────
      kdePackages.ark # KDE GUI archive manager
      kdePackages.kio-admin # KDE file management with administrator (root) privileges
      file-roller # GNOME archive manager with broad format support
      meld # Visual diff and three-way merge tool
      unzip # Extract ZIP archives
      unar # Universal unarchiver (handles many legacy formats)
      _7zz # 7-Zip CLI archiver
      _7zz-rar # 7-Zip with RAR archive support
      rar # RAR archiver and extractor
      arj # ARJ legacy archive tool
      commons-compress # Apache Commons Compress library (archive format support)

      # ── Productivity & Office ─────────────────────────────────────────────────
      libreoffice # Full-featured open-source office suite
      hunspell # Spell checker library
      hunspellDicts.en_US # Hunspell English (US) dictionary
      hunspellDicts.en-us # Hunspell English (US) dictionary (alternate package name)
      eog # GNOME image viewer
      impression # Bootable USB drive creator (simple GUI)
      usbimager # Minimal bootable USB image writer

      # ── Vulkan ────────────────────────────────────────────────────────────────
      vulkan-loader # Vulkan ICD loader
      vulkan-validation-layers # Vulkan validation layers for debugging and development
      vulkan-tools # Vulkan utilities (vulkaninfo, vkcube)

      # ── Libraries & System Dependencies ──────────────────────────────────────
      glib # GLib core library (required for gsettings to work)
      libappindicator # Status indicator/tray applet library
      openssl # TLS/SSL cryptography library (required by Rainbow borders)
      libsecret # Library for storing and retrieving secrets via keyring
      egl-wayland # EGL Wayland platform support (NVIDIA Wayland compatibility)
      polkit # Authorization framework for privileged operations
      xdg-user-dirs # Manage XDG user directories (Downloads, Pictures, etc.)
      xdg-utils # XDG command-line tools (xdg-open, xdg-mime, etc.)
      xdg-desktop-portal-gtk # GTK backend for the XDG desktop portal
      libei # Input emulation library
      libportal # XDG portal convenience library
      service-wrapper # Wrapper for running commands as systemd services

      # ── Input Devices ─────────────────────────────────────────────────────────
      libratbag # Configuration driver for gaming mice
      piper # GTK frontend for libratbag gaming mouse configuration

      # ── Bluetooth ─────────────────────────────────────────────────────────────
      overskride # Bluetooth manager with a clean GTK/Wayland interface

      # ── Android & USB Tools ───────────────────────────────────────────────────
      android-tools # ADB, fastboot, and other Android platform tools

      # ── AI & Local LLMs ───────────────────────────────────────────────────────
      lmstudio # GUI application for running and chatting with local LLMs

      # ── Misc ──────────────────────────────────────────────────────────────────
      limo # (verify — purpose unclear; remove if unused)
      spotify # Spotify music streaming client
    ];
  };
}
