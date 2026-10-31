# Generic AMD GPU (amdgpu/ROCm) enablement baseline, extracted from
# hosts/missingno (Framework Desktop AMD AI Max 300 / Strix Halo). Owns the
# parts every AMD GPU host shares — the kernel module, firmware, the
# hardware.graphics GL/Vulkan/ROCm userspace stack, and the X11 driver
# choice — while host-specific values (kvm-amd, WLR_DRM_DEVICES, the gfx
# version override) stay with the host or are set through the options
# below. Every value is mkDefault so a host's own plain assignments win.
#
# GPU timeline — what loads, when, and why:
#   1. initrd: amdgpu ships in the initial ramdisk so early-KMS drives the
#      boot console before the real root mounts.
#   2. kernel: the amdgpu DRM driver binds the GPU PCIe function, fetches
#      device firmware from linux-firmware (enableRedistributableFirmware),
#      and exposes /dev/dri/cardN plus /sys/class/drm/cardN/device (hwmon
#      sensors, gpu_busy_percent, VRAM/GTT accounting) and the /dev/kfd
#      compute node that ROCm runtimes use for GPU work.
#   3. userspace: hardware.graphics installs Mesa (RADV Vulkan driver), the
#      Vulkan loader and validation layers, and the ROCm compute runtime
#      (HIP/OpenCL via clr, cuBLAS-compatible hipBLAS/rocBLAS) system-wide.
#   4. consumers: X11 via services.xserver.videoDrivers, Wayland
#      compositors (hyprland) through DRM, and ROCm workloads —
#      llama.cpp/halogen-flash-server inference, Steam gaming — via the
#      installed runtimes.
#
# Observability: when the node exporter is enabled (e.g. via modules/logging
# or modules/prometheus), this module also turns on its `drm` collector,
# exporting node_drm_gpu_busy_percent, node_drm_memory_vram_* and
# node_drm_memory_gtt_*; these reach Prometheus through the existing alloy
# node scrape. GPU temperature and power already flow via node_exporter's
# default-on hwmon collector, and amdgpu kernel messages reach Loki through
# the journal log pipeline.
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.hardware.amd-gpu;
in
{
  options.hardware.amd-gpu = {
    enable = mkEnableOption "AMD GPU (amdgpu/ROCm) support";

    hsaOverrideGfxVersion = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "11.5.1";
      description = ''
        Value for HSA_OVERRIDE_GFX_VERSION, used to target a supported ROCm
        ISA when the installed ROCm release lacks native support for the
        GPU (e.g. gfx1151 APUs advertising 11.5.1).
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # Additive lists: merge with any disk/CPU modules the host lists.
    boot = {
      initrd.kernelModules = [ "amdgpu" ];
      kernelModules = [ "amdgpu" ];
    };

    environment = {
      # ROCm library paths for login sessions and services.
      sessionVariables = {
        LD_LIBRARY_PATH = lib.mkDefault [
          "${pkgs.rocmPackages.rocm-smi}/lib"
          "${pkgs.libdrm}/lib"
        ];
        HSA_OVERRIDE_GFX_VERSION = lib.mkIf (cfg.hsaOverrideGfxVersion != null) (
          lib.mkDefault cfg.hsaOverrideGfxVersion
        );
      };

      systemPackages = with pkgs; [
        vulkan-headers
        vulkan-tools
        vulkan-loader
        vulkan-validation-layers
        rocmPackages.rocm-smi
        rocmPackages.rocminfo
        rocmPackages.clr
      ];
    };

    hardware = {
      enableRedistributableFirmware = lib.mkDefault true;

      graphics = {
        enable = lib.mkDefault true;
        extraPackages = with pkgs; [
          mesa
          rocmPackages.clr
          rocmPackages.hipblas
          rocmPackages.rocblas
          rocmPackages.clr.icd
          vulkan-tools
          vulkan-loader
          vulkan-validation-layers
        ];
      };
    };

    services = {
      # Expose node_drm_* GPU metrics via the node exporter when it is
      # enabled; the existing alloy node scrape ships them to Prometheus.
      prometheus.exporters.node.enabledCollectors =
        lib.mkIf config.services.prometheus.exporters.node.enable
          [ "drm" ];

      # Plain assignment (not mkDefault): nixpkgs defaults videoDrivers to
      # ["modesetting"] and list defaults merge, so mkDefault would yield
      # ["modesetting" "amdgpu"]. Same approach as modules/nvidia.
      xserver.videoDrivers = [ "amdgpu" ];
    };
  };
}
