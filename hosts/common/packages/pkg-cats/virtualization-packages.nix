{
  lib,
  pkgs,
  config,
  ...
}:
{
  options = {
    packages.virtualization-packages.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = true;
    };
  };

  config = lib.mkIf config.packages.virtualization-packages.enable {
    environment = {
      systemPackages = with pkgs; [
        # ── Virtualization & Sandboxing ───────────────────────────────────────────
        virt-manager # GUI for managing QEMU/KVM virtual machines
        virt-viewer # Lightweight viewer for virtual machine displays
        spice # SPICE remote display protocol support
        spice-gtk # GTK client widget for SPICE connections
        spice-protocol # SPICE protocol headers and definitions
        quickemu # Quickly create and run optimized QEMU virtual machines
        bubblewrap # Unprivileged sandboxing and lightweight container tool
      ];
    };
  };
}
