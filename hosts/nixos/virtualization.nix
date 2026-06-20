{ username, ... }: {
  boot.kernelParams = [
    "amd_iommu=on"
    "iommu=pt"
    # Blindfold the host from touching the RTX 3050
    "vfio-pci.ids=10de:2584,10de:2291"

    "kvmfr.static_size_mb=128"
  ];

  boot.initrd.kernelModules = [
    "vfio"
    "vfio_pci"
    "vfio_iommu_type1"
    "kvm-amd"
  ];

  boot.kernelModules = [
    "kvmfr"
  ];

  services.udev.extraRules = ''
    # Enable runtime power management for the RTX 3050
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{device}=="0x2584", ATTR{power/control}="auto"
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{device}=="0x2291", ATTR{power/control}="auto"

    # 4. Correct modern permissions rules for the KVMFR character device
    SUBSYSTEM=="kvmfr", GROUP="kvm", MODE="0660", TAG+="uaccess"
  '';

  virtualisation.libvirtd.qemu.verbatimConfig = ''
    namespaces = []
    cgroup_device_acl = [
      "/dev/null", "/dev/full", "/dev/zero",
      "/dev/random", "/dev/urandom",
      "/dev/ptmx", "/dev/kvm", "/dev/vfio/vfio",
      "/dev/kvmfr0"
    ]
  '';

  # Create the Inter-VM Shared Memory (IVSHMEM) layer for Looking Glass
  systemd.tmpfiles.rules = [
    # Creates /dev/shm/looking-glass at boot, assigns it to your user group
    "f /dev/shm/looking-glass 0660 ${username} kvm -"
  ];
}
