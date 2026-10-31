# Reusable Strix Halo (gfx1151) system tuning baseline: recommended kernel
# parameters and ROCm/graphics environment variables, observed from the
# offsite.guru blog (https://offsite.guru/blog/halogen-strix-halo/) and the
# javierarrieta/halogen-flash-flake. Every value is mkDefault so a host's own
# plain assignments (e.g. hosts/*/hw.nix) still win and nothing hard-conflicts.
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.hardware.strix-halo;
in
{
  options.hardware.strix-halo = {
    enable = mkEnableOption "Strix Halo (gfx1151) system tuning baseline";

    applyKernelParams = mkOption {
      type = types.bool;
      default = true;
      description = "Apply the recommended kernel parameters.";
    };

    applyEnvironment = mkOption {
      type = types.bool;
      default = true;
      description = "Apply the recommended ROCm/graphics environment variables.";
    };
  };

  config = lib.mkIf cfg.enable {
    # Recommended tuning per the offsite.guru blog (amd_iommu=off is its one
    # measured perf win: 13-16% prefill). NOTE: boot.kernelParams merges by
    # concatenation, so a host that also sets these (e.g. hw.nix) will see
    # harmless duplicate parameters on the kernel command line. Deliberately
    # NOT mkDefault here: a mkDefault list definition is dropped outright in
    # favour of any plain host definition, instead of concatenating with it.
    boot.kernelParams = lib.mkIf cfg.applyKernelParams [
      "amd_iommu=off"
      "amdgpu.gttsize=126976"
      "amdgpu.vm_fragment_size=8"
      "amdgpu.vm_update_mode=0"
      "amdgpu.sg_display=0"
      "ttm.pages_limit=32505856"
      "ttm.page_pool_size=25165824"
      "amdttm.pages_limit=32505856"
    ];

    # ROCm/graphics environment recommended by the blog/flake. mkDefault on
    # each value so equal host values do not conflict.
    environment.variables = {
      ROC_ENABLE_PRE_VEGA = lib.mkDefault "1";
      AMD_VULKAN_ICD = lib.mkDefault "RADV";
      HSA_ENABLE_SDMA = lib.mkDefault "0";
      HSA_OVERRIDE_GFX_VERSION = lib.mkDefault "11.5.1";
    };
  };
}
