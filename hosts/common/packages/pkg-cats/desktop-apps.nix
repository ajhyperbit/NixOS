{
  lib,
  pkgs,
  config,
  ...
}:
{
  options = {
    packages.desktop-apps.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = true;
      description = ''
        Desktop application bundle: browsers, games and emulators,
        communication clients, audio/video tools, OBS Studio with
        plugins, screenshot and clipboard utilities, Hyprland/Wayland
        shell tools, file managers, office suites, and miscellaneous
        desktop programs.
      '';
    };
  };

  config = lib.mkIf config.packages.desktop-apps.enable {
    environment = {
      systemPackages = with pkgs; [
        # ── Browsers ──────────────────────────────────────────────────────────────
        google-chrome # Google Chrome browser
        chromium # Open-source Chromium browser
        floorp-bin # Firefox-based privacy-focused browser
        stable.firefox-devedition # Firefox Developer Edition with devtools

        # ── Gaming & Emulation ────────────────────────────────────────────────────
        mangohud # Vulkan/OpenGL overlay for FPS, CPU/GPU usage, and temps
        rare # Epic Games Store launcher GUI for Linux
        # rpcs3 # PlayStation 3 emulator
        ryubing # Nintendo Switch emulator (Ryujinx community fork)
        fusee-nano # Fusée Gelée payload injector for Nintendo Switch hacking
        theclicker # Auto-clicker
        limo # General purpose mod manager with support for the NexusMods API and LOOT

        # ── Communication ─────────────────────────────────────────────────────────
        (discord.override {
          # Discord with OpenASAR performance patches
          withOpenASAR = true;
        })
        # vesktop # Alternate Discord client with Vencord built in
        #zoom-us # Zoom video conferencing client

        # ── Audio & Video ─────────────────────────────────────────────────────────
        ffmpeg # Comprehensive multimedia transcoding and processing toolkit
        (mpv.override {
          # Media player with MPRIS support for media keys and tray
          scripts = [ mpvScripts.mpris ];
        })
        vlc # Versatile media player supporting many formats
        handbrake # Tool for converting video files and ripping DVDs
        pavucontrol # PulseAudio/PipeWire volume control GUI
        pamixer # PulseAudio/PipeWire CLI mixer
        playerctl # MPRIS media player controller for scripts and keybinds
        pulseaudio # PulseAudio CLI utilities (pactl, pacmd, etc.)
        cava # Console-based audio visualizer
        streamlink # Pipe Twitch and other streams into a local player
        yt-dlp # YouTube and multi-site video/audio downloader
        v4l-utils # Video4Linux2 utilities for webcams and capture cards
        libcec # HDMI-CEC device control library and utilities
        blanket # Listen to different sounds
        audacity # Sound editor with graphical UI

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
        switcheroo # App for converting images between different formats

        # ── Productivity & Office ─────────────────────────────────────────────────
        libreoffice # Full-featured open-source office suite
        onlyoffice-desktopeditors # Full-featured open-source office suite, again
        hunspell # Spell checker library
        hunspellDicts.en_US # Hunspell English (US) dictionary
        hunspellDicts.en-us # Hunspell English (US) dictionary (alternate package name)
        eog # GNOME image viewer
        impression # Bootable USB drive creator (simple GUI)
        usbimager # Minimal bootable USB image writer
        appflowy # Open-source alternative to Notion

        # ── Terminal ──────────────────────────────────────────────────────────────
        kitty # Fast, feature-rich, GPU based terminal emulator

        # ── Misc ──────────────────────────────────────────────────────────────────
        spotify # Spotify music streaming client
        manim # Animation engine for explanatory math videos
        # handy # Free, open source, offline speech-to-text application
      ];
    };
  };
}
