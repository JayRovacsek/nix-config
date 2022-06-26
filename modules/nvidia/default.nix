{ config, pkgs, lib, ... }:
let
  patchDriver = import ./nvenc-unlock.nix;
  # So the below is really an option: if we have imported the module to enable
  # vGPU then we assume this is our intent and apply the vGPU patch. This is 
  # not compatiable with NVENC and NVFBC hacks as the hardware.nvidia.package
  # value is crucial to vGPU functionality as per: https://github.com/JayRovacsek/nixos-nvidia-vgpu/blob/a4be77969dc2a8acbe3a4882ba5f0324cca138b6/default.nix#L78
  # However if we haven't imported vGPU module we'll default to patching the 
  # GPU drivers to give us those sweet capabilities on consumer hardware
  baseConfig = if builtins.hasAttr "vgpu" config.hardware.nvidia then {
    vgpu.enable = true; # Enable NVIDIA KVM vGPU + GRID driver
    vgpu.unlock.enable =
      true; # Unlock vGPU functionality on consumer cards using DualCoder/vgpu_unlock project.
  } else {
    package = patchDriver config.boot.kernelPackages.nvidiaPackages.stable;
  };
in {
  # Required to remedy weird crash when using nvidia in docker
  systemd.enableUnifiedCgroupHierarchy = false;

  hardware = {
    opengl = {
      enable = true;
      driSupport32Bit = true;
    };
    nvidia = baseConfig // { modesetting.enable = true; };
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  environment.systemPackages = with pkgs; [ linuxPackages.nvidia_x11 ];
}
