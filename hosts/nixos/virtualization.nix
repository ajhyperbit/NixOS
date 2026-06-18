{ username, ... }: {
  boot.kernelParams = [
    "amd_iommu=on"
    "iommu=pt"
    # Blindfold the host from touching the RTX 3050
    #"vfio-pci.ids=10de:2507,10de:228e"
  ];

  boot.initrd.kernelModules = [
    "vfio"
    "vfio_pci"
    "vfio_virqfd"
    "vfio_iommu_type1"
    "kvm-amd"
  ];

  # Create the Inter-VM Shared Memory (IVSHMEM) layer for Looking Glass
  systemd.tmpfiles.rules = [
    # Creates /dev/shm/looking-glass at boot, assigns it to your user group
    "f /dev/shm/looking-glass 0660 ${username} kvm -"
  ];
}
