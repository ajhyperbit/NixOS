{ ... }:
{
  boot.loader.systemd-boot.extraEntries = {
    "00-Gen-715.conf" = ''
    title NixOS Gen-715
    sort-key nixos
    version Generation 715 NixOS Yarara 26.05.20260204.bf922a5 (Linux 6.18.7-zen1), built on 2026-02-08
    linux /EFI/nixos/nbivb3yljdc1v46zd90mgqrvn6awc216-linux-zen-6.18.7-bzImage.efi
    initrd /EFI/nixos/d8p55g9yh4818kjiy712qq9bmd1n1jr8-initrd-linux-zen-6.18.7-initrd.efi
    options init=/nix/store/lcy9fm2xdcw9543jacsajmy7r8kvk1ca-nixos-system-nixos-26.05.20260204.bf922a5/init amd_pstate=active systemd.mask=systemd-vconsole-setup.service systemd.mask=dev-tpmrm0.device nowatchdog nohibernate amd_iommu=on loglevel=4 lsm=landlock,yama,bpf crashkernel=128M nmi_watchdog=panic softlockup_panic=1
    machine-id bfbed59964754db3945d2f70ff0a6caa
    '';
  };
}
