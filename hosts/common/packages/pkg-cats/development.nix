{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
{
  options = {
    packages.development.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = true;
    };
  };

  config = lib.mkIf config.packages.development.enable {
    environment = {
      systemPackages = with pkgs; [
        # ── CLI & Term Utilities ──────────────────────────────────────────────────
        lsof # List open files and file descriptors
        strace # System call tracer for debugging
        socat # Multipurpose relay for bidirectional data transfer
        wget # Non-interactive network file downloader
        curl # Command-line HTTP/FTP client
        jq # Command-line JSON processor
        file # Determine file type by magic bytes
        rsync # Fast incremental file transfer utility
        tmux # Terminal multiplexer
        expect # Automate interactive terminal programs
        procps # Core process utilities (ps, top, kill, etc.)
        psmisc # Additional process utilities (killall, fuser, pstree)
        bind # DNS lookup utilities (dig, nslookup)
        traceroute # Trace network path to a host
        ethtool # Query and control network driver and hardware settings
        dialog # Create TUI dialog boxes from shell scripts
        eza # Modern ls replacement with color, icons, and git info
        duf # Disk usage viewer with a clean TUI layout
        dysk # Filesystem info viewer (df alternative)
        chafa # Render images as Unicode/ANSI art in the terminal
        ydotool # Input event injector (keyboard/mouse automation)
        cloc # Count lines of code across source files and languages
        inxi # Comprehensive system information CLI tool
        tree # Command to produce a depth indented directory listing
        caligula # Lightweight TUI for disk imaging

        # ── Editors & IDEs ────────────────────────────────────────────────────────
        neovim # Extensible Vim-based text editor
        nano # Simple terminal text editor
        vscode-fhs # Visual Studio Code in an FHS-compatible environment
        vscodium-fhs # VSCodium (open-source VS Code) in an FHS-compatible environment
        kdePackages.kate # KDE feature-rich text editor

        # ── Development & Coding ──────────────────────────────────────────────────
        gitFull # Git with all extras (send-email, svn bridge, etc.)
        gh # GitHub CLI for repos, PRs, issues, and Actions
        meson # Fast and user-friendly build system
        bun # JavaScript runtime, bundler, and package manager
        virtualenv # Python virtual environment manager
        shfmt # Shell script formatter
        cyberchef # Browser-based data encoding, encryption, and analysis tool

        # ── Nix Tooling ───────────────────────────────────────────────────────────
        nixos-generators # Generate NixOS images for various deployment targets
        nixfmt # Official formatter for Nix code
        inputs.alejandra.defaultPackage.${stdenv.hostPlatform.system} # Opinionated Nix code formatter
        direnv # Automatically load/unload env vars per directory
        nvd # Nix/NixOS package version diff tool
        nix-output-monitor # Prettier output for nix build commands
      ];
    };
  };
}
