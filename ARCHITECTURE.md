# Architecture & Deep Dive

This document explores the design decisions, subsystem implementations, and tooling behind this NixOS configuration. For a high-level overview, start with the **[README](README.md)**.

## Design Philosophy

- **Single source of truth** — One flake defines everything: system packages, user dotfiles, secrets, disk layout, kernel parameters, and services. No imperative setup scripts.
- **Hosts inherit from common** — Machine-specific config lives in `hosts/<hostname>/`; shared logic lives in `hosts/common/`. The `nixos-otg` host is an in-progress portable variant.
- **Modules are reusable** — Driver modules (`modules/`) and the `webhost` module (`hosts/common/webhost/`) expose NixOS option interfaces so they can be composed cleanly.
- **Everything is pinned** — The flake lock file provides exact input hashes. `follows` directives in inputs avoid duplicate `nixpkgs` instances.

### Repository Hosting

This repository is primarily hosted on the self-hosted Forgejo instance at [git.ajhyperbit.dev](https://git.ajhyperbit.dev) — configured through the `webhost` module in this project. Due to Cloudflare access rules, external access may be restricted. The [GitHub mirror](https://github.com/ajhyperbit/nixos) remains the primary channel for issues and pull requests.

---

## Directory Structure

```
.
├── flake.nix                   # Entrypoint: all inputs, nixosConfigurations, formatters, devShells
├── flake.lock                  # Pinned input hashes
├── format/treefmt.nix          # Formatter configuration (alejandra, nixfmt, deadnix, shellcheck)
├── sops/
│   ├── config.nix              # SOPS-Nix module: default key and file paths
│   └── secrets/secrets.yaml    # Encrypted secrets (API keys, TLS certs, tokens)
├── modules/
│   ├── amd-drivers.nix         # AMD GPU driver module
│   ├── nvidia-drivers.nix      # NVIDIA driver module with configurable options
│   ├── intel-drivers.nix       # Intel GPU driver module
│   ├── nvidia-prime-drivers.nix # NVIDIA Prime (hybrid graphics) module
│   ├── vm-guest-services.nix   # SPICE/QEMU guest agent services
│   ├── iso.nix                 # ISO image generation settings
│   └── local-hardware-clock.nix # RTC in local time (dual-boot compatibility)
├── hosts/
│   ├── nixos/                  # Main desktop configuration
│   │   ├── config.nix          # Hardware-specific: CPU microcode, kernel modules, networking
│   │   ├── ai.nix              # Ollama + ROCm + OpenCode + Continue integration
│   │   ├── audio.nix           # PipeWire audio pipeline
│   │   ├── cachyos-kernel.nix  # CachyOS kernel override
│   │   ├── drives.nix          # Filesystem mounts
│   │   ├── nixos-hm.nix        # Home Manager bridge (passes specialArgs)
│   │   ├── nvidia.nix          # Secondary GPU (RTX 3050) driver config
│   │   ├── virtualization.nix  # VFIO binding, KVMFR, libvirt tunables
│   │   ├── gpg-agent.nix       # GPG agent SSH socket configuration
│   │   ├── input.nix           # Keyboard, mouse, input devices
│   │   └── disko/              # Declarative disk partitioning
│   ├── common/                 # Shared across all hosts
│   │   ├── common.nix          # Core system: boot, networking, locale, services
│   │   ├── hyprland/           # Compositor, greetd, UWSM, Hyprlock, Hypridle
│   │   ├── packages/           # Package category system (see below)
│   │   ├── users.nix           # User definitions
│   │   ├── fonts.nix           # System fonts
│   │   ├── security/           # Kernel sysctl hardening
│   │   ├── webhost/            # Self-hosting module (Forgejo, Grafana, Cloudflare)
│   │   ├── virtualization.nix  # Shared virt config (libvirt, QEMU)
│   │   ├── vscode.nix          # Declarative VSCode/VSCodium extensions
│   │   ├── nix-alien.nix       # nix-alien for running unpatched binaries
│   │   ├── desktop-entries/    # XDG MIME default applications
│   │   ├── dotfiles/git.nix    # Git user config
│   │   └── home.nix            # Home Manager: cursor, Qt theming
│   └── nixos-otg/              # Portable/on-the-go config (in progress)
├── scripts/
│   ├── rebuild-flake.sh        # Main rebuild wrapper
│   ├── update-flake.sh         # Update flake.lock + commit
│   ├── trim-generations.sh     # Garbage-collect old Nix generations
│   └── tag.sh                  # Tag successful rebuilds
└── tips-and-tricks.txt         # Nix troubleshooting notes
```

---

## Developer Tooling

**Formatters** (`format/treefmt.nix`):
- `alejandra` (priority 1) and `nixfmt` (priority 2) for Nix files
- `deadnix` to catch unused variables
- `shellcheck` + `shfmt` for shell scripts

Run with: `nix fmt`

**Flake structure:**
- `flake-parts` / `flake-utils` for system abstraction
- `eachSystem` helper generates `devShells`, `formatter`, and `checks` for all supported systems
- Input `follows` minimize `nixpkgs` duplication across the dependency tree

**Quality of life:**
- `direnv` + `nix-direnv` for automatic environment loading
- `nix-index-database` + `nix-alien` for running unpatched FHS binaries
- `nh clean` scheduled monthly to garbage-collect old store paths

---

## Package Category System

Packages are organized into toggleable categories under `hosts/common/packages/pkg-cats/`. Each file defines an `options.packages.<category>.enable` boolean, and `pkgs-module.nix` auto-imports every `.nix` file in the directory:

```nix
dir = ./pkg-cats;
nixFiles = lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name)
  (builtins.readDir dir);
```

Example category structure:

| File | Option |
|------|--------|
| `development.nix` | `packages.development.enable` |
| `desktop-apps.nix` | `packages.desktop-apps.enable` |
| `system-tools.nix` | `packages.system-tools.enable` |
| `themes-fonts.nix` | `packages.themes-fonts.enable` |
| `virtualization-packages.nix` | `packages.virtualization-packages.enable` |
| `wine.nix` | `packages.wine.enable` |
| `usb-devices.nix` | `packages.usb-devices.enable` |
| `libraries.nix` | `packages.libraries.enable` |
| `ardunio.nix` | `packages.ardunio.enable` |
| `plasma.nix` | `packages.plasma.enable` |

Additionally, Proton GE versions are defined as overlay packages under `package-overlays/proton-ge-overlays/`, with each version pinned by URL and SHA256 hash.

---

## Web Hosting Stack

The `hosts/common/webhost/` directory defines a reusable NixOS module for self-hosting. It exposes options for:

- **Forgejo** — Git forge instance, served behind NGINX with SSL
- **Grafana** — Monitoring dashboard, API key stored in SOPS
- **Cloudflare Tunnel** — `cloudflared` tunnel for secure origin exposure without open ports
- **Domain routing** — Configurable domain, SSH, and email settings

Secrets (origin certificate private key, tunnel credentials, Grafana key) are decrypted from `sops/secrets/secrets.yaml` and exposed as file paths readable by the relevant services:

```nix
sops.secrets = {
  cloudflareOriginCertPK = {
    path = "/etc/ssl/ajhyperbit.dev/cloudflare-origin-pk.pem";
    owner = "nginx";
    restartUnits = [ "nginx.service" ];
  };
};
```

---

## Secret Management (SOPS)

All secrets live in `sops/secrets/secrets.yaml`, encrypted with age keys. The SOPS-Nix module is imported in `sops/config.nix`:

```nix
sops = {
  defaultSopsFile = ./secrets/secrets.yaml;
  defaultSopsFormat = "yaml";
  age.keyFile = "/etc/sops/age/keys.txt";
};
```

The `.sops.yaml` file defines two age recipients (primary key + host SSH-age key) with a path regex matching the secrets file. Secrets are never stored in the Nix store — they are decrypted at activation time and placed at configurable paths.

---

## GPU Passthrough (VFIO)

The `hosts/nixos/virtualization.nix` module isolates the NVIDIA RTX 3050 at boot for exclusive use by a Windows VM:

```nix
boot.kernelParams = [
  "amd_iommu=on"
  "iommu=pt"
  "vfio-pci.ids=10de:2584,10de:2291"  # GPU + audio function
  "kvmfr.static_size_mb=128"
];
boot.initrd.kernelModules = [ "vfio" "vfio_pci" "vfio_iommu_type1" "kvm-amd" ];
```

**Looking Glass (KVMFR)** — The host creates a shared memory device (`/dev/shm/looking-glass`) and a KVMFR character device. QEMU is configured with `cgroup_device_acl` to expose `/dev/kvmfr0` and `/dev/shm/looking-glass` to the guest. The RTX 3050's runtime power management is enabled via udev when not in use by the VM.

**Samba bridging** — Three SMB shares (`/home`, `/run/media`, `/mnt`) allow the Windows VM to access the host filesystem over the virtual network, and are also accessible from other devices on the Tailscale mesh.

---

## Kernel & Network Hardening

The `hosts/common/security/security.nix` module applies kernel sysctl hardening inspired by [hlissner's dotfiles](https://github.com/hlissner/dotfiles/blob/1d9e55a5525c0c57807b15c020182f3dac85f5c8/modules/security.nix):

```nix
boot.kernel.sysctl = {
  "net.ipv4.tcp_syncookies" = 1;         # SYN flood protection
  "net.ipv4.conf.all.rp_filter" = 1;     # Source validation (anti-spoofing)
  "net.ipv4.conf.all.accept_source_route" = 0;  # Disable source routing
  "net.ipv4.conf.all.accept_redirects" = 0;     # Block ICMP redirects (MITM)
  "net.ipv4.tcp_congestion_control" = "bbr";    # BBR congestion control
  "net.core.default_qdisc" = "cake";            # Bufferbloat mitigation
  "net.ipv4.tcp_rfc1337" = 1;                   # TIME-WAIT assassination protection
};
boot.kernelModules = [ "tcp_bbr" ];
```

---

## Rebuild Workflow

`rebuild-flake.sh` is the primary interface for system updates:

```
Usage: ./rebuild-flake.sh <host> <action>

  host:            Hostname from nixosConfigurations (e.g., "nixos")
  action:          switch | boot | test | build | dry-activate
```

**Flow:**
1. Prompts whether to update `flake.lock` (runs `update-flake.sh` which does `nix flake update` + `git commit`)
2. Runs `nh os <action> -H <host>` with a sudo keep-alive background process
3. Logs output to `nixos-switch.log`
4. Prints a generation identifier: `Gen-<hostname>-<gen>-<git-hash>[-dirty]`

Additional scripts:
- `tag.sh` — Tags the current generation for git-based rollback
- `trim-generations.sh` — Garbage-collects old Nix generations with configurable retention
- `flake-check.sh` — Runs `nix flake check` and filters errors

---

## AI / LLM Infrastructure

The `hosts/nixos/ai.nix` module configures a complete local AI stack:

**Ollama with ROCm** — The `ollama-rocm` package enables AMD GPU acceleration. Model parameters (`num_ctx`) are defined per-model in a Nix attribute set and rendered into Modelfiles:

```nix
ollamaModelConfigs = {
  "qwen3-coder:30b" = {
    numCtx = 8192;
    output = 4096;
    name = "Qwen 3 Coder 30b";
    roles = [ "chat" "edit" "apply" ];
  };
  "gemma4:26b" = {
    numCtx = 8192;
    output = 4096;
    name = "Gemma 4 26b";
    roles = [ "chat" "edit" "apply" "embed" ];
  };
  # ...
};
```

A Nix-generated shell script applies these Modelfiles via a oneshot systemd service (`ollama-apply-modelfiles`) that waits for the Ollama daemon to be ready.

**IDE Integration** — Both OpenCode and Continue are configured declaratively through Home Manager:
- OpenCode's `opencode.jsonc` is generated by `pkgs.formats.json` with per-model context/output limits
- Continue's `config.yaml` lists each model with its roles (`chat`, `edit`, `apply`, `embed`)

**OpenRouter fallback** — The OpenRouter API key is stored in SOPS secrets and materialized at `~/.local/share/opencode/auth.json`.
