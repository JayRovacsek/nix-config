{ config, pkgs, ... }: {
  virtualisation.libvirtd = {
    onBoot = "start";
    onShutdown = "shutdown";
    enable = true;
    qemu = { runAsRoot = false; };
  };
  environment.systemPackages = with pkgs; [ virt-manager ];
}
