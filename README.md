# NixOS-Hyprland

A fully declarative NixOS configuration — desktop, development, gaming, AI, and self-hosting, all from a single flake.

![NixOS](https://img.shields.io/badge/NixOS-unstable-blue?logo=nixos)
![License](https://img.shields.io/badge/license-MIT-green)

## Overview

This repository defines the entire system configuration for my primary desktop, a Hyprland-based NixOS machine. Every package, service, kernel parameter, dotfile, and secret is declared in Nix. The goal is reproducibility: a single `nixos-rebuild` (or `nh os switch`) reconstructs the full environment from bare metal.

## Highlights

- **Secret management** — SOPS encrypts secrets (API keys, TLS certs, Cloudflare tokens) at rest; decrypted only at build time and exposed as systemd-accessible paths
- **Modular package categories** — Packages are organized into toggleable NixOS options (`packages.development.enable`, `packages.desktop-apps.enable`, etc.) with auto-import of every `.nix` file in `pkg-cats/`
- **GPU passthrough (VFIO)** — RTX 3050 isolated at boot for a Windows VM; Looking Glass (KVMFR) for near-native display, with `smb` shares bridging filesystems and accessible over Tailscale
- **Declarative AI stack** — Ollama with ROCm acceleration, per-model parameter overrides via Nix-generated Modelfiles, and IDE integration (OpenCode, Continue) all wired through Home Manager
- **Self-hosted infrastructure** — Forgejo, Grafana, and Cloudflare Tunnel defined as a reusable `webhost` module, all routed through a custom domain
- **Kernel & network hardening** — Sysctl TCP/IP hardening (BBR congestion control, SYN flood protection, reverse-path filtering), kernel parameter tuning, and ZRAM swap
- **Hyprland ecosystem** — UWSM session management, Stylix theming, Noctalia notification center, Rose Pine cursors, and greetd with tuigreet
- **CI-style tooling** — `treefmt` with alejandra + nixfmt + deadnix + shellcheck for code quality; custom rebuild scripts with generation tagging and `nh` integration

## Architecture

```
flake.nix                  Flake entrypoint — inputs, outputs, nixosConfigurations
hosts/
  nixos/                   Main desktop (AMD CPU + dGPU, RTX 3050 for passthrough)
  common/                  Shared config consumed by all hosts
    hyprland/              Compositor, greeter, screen lock, idle management
    packages/              Toggleable package categories (auto-imported)
    webhost/               Forgejo, Grafana, Cloudflare Tunnel module
    security/              Kernel sysctl hardening
modules/                   Reusable hardware driver modules (NVIDIA, AMD, Intel, VM guests)
sops/                      Encrypted secrets + SOPS-Nix integration
scripts/                   Flake update, generation trimming, tagging
format/                    treefmt configuration
```

## Hardware (Main Desktop)

| Component   | Detail                          |
|-------------|---------------------------------|
| CPU         | AMD Ryzen 5700X3D  (Zen)        |
| Primary GPU | AMD Radeon 9070 XT (amdgpu)     |
| Passthrough | NVIDIA RTX 3050 (VFIO isolated) |
| Kernel      | linux-zen / CachyOS (optional)  |

## Quick Start

```bash
# Rebuild the main host
./rebuild-flake.sh nixos switch

# Format all Nix and shell files
nix fmt

# Run flake checks (formatting + evaluation)
nix flake check
```

The rebuild script primarily wraps `nh os switch`, prompts for a flake.lock update, tags successful generations, and logs output to `nixos-switch.log`.

## Key Technologies

| Tool | Purpose |
|------|---------|
| [Hyprland](https://hyprland.org) | Wayland compositor |
| [Home Manager](https://nix-community.github.io/home-manager/) | User environment & dotfiles |
| [sops-nix](https://github.com/Mic92/sops-nix) | Secret management |
| [disko](https://github.com/nix-community/disko) | Declarative disk partitioning |
| [CachyOS kernel](https://github.com/xddxdd/nix-cachyos-kernel) | Performance-optimized kernel |
| [Noctalia](https://github.com/noctalia-dev/noctalia) | Notification center for Hyprland |
| [treefmt](https://github.com/numtide/treefmt-nix) | Multi-formatter runner |
| [nh](https://github.com/oddlama/nh) | NixOS helper CLI |
| [nix-alien](https://github.com/thiagokokada/nix-alien) | Run unpatched binaries on NixOS |

---

For a deep technical walkthrough with code examples, see **[ARCHITECTURE.md](ARCHITECTURE.md)**.

## License

MIT — see [LICENSE.md](LICENSE.md).
