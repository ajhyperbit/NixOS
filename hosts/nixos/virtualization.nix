{ username, ... }: {
  boot.kernelParams = [
    "amd_iommu=on"
    "iommu=pt"
    # Blindfold the host from touching the RTX 3050
    "vfio-pci.ids=10de:2584,10de:2291"
  ];

  boot.initrd.kernelModules = [
    "vfio"
    "vfio_pci"
    "vfio_iommu_type1"
    "kvm-amd"
  ];

  services.udev.extraRules = ''
    # Enable runtime power management for the RTX 3050 Video Controller
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{device}=="0x2584", ATTR{power/control}="auto"

    # Enable runtime power management for the RTX 3050 Audio Controller
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{device}=="0x2291", ATTR{power/control}="auto"
  '';

  # Create the Inter-VM Shared Memory (IVSHMEM) layer for Looking Glass
  systemd.tmpfiles.rules = [
    # Creates /dev/shm/looking-glass at boot, assigns it to your user group
    "f /dev/shm/looking-glass 0660 ${username} kvm -"
  ];
}
