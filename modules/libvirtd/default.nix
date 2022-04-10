{
  virtualisation.libvirtd = {
    onBoot = "start";
    onShutdown = "shutdown";
    enable = true;
    qemu = { runAsRoot = false; };
  };
}
