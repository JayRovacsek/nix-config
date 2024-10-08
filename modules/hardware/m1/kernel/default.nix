# the Asahi Linux kernel and options that must go along with it

{
  config,
  pkgs,
  lib,
  ...
}:
{
  config = {
    boot = {
      # kernel parameters that are useful for debugging
      consoleLogLevel = 7;
      kernelParams = [
        "earlycon"
        "console=ttySAC0,1500000"
        "console=tty0"
        "debug"
        "boot.shell_on_fail"
        # Apple's SSDs are slow (~dozens of ms) at processing flush requests which
        # slows down programs that make a lot of fsync calls. This parameter sets
        # a delay in ms before actually flushing so that such requests can be
        # coalesced. Be warned that increasing this parameter above zero (default
        # is 1000) has the potential, though admittedly unlikely, risk of
        # UNBOUNDED data corruption in case of power loss!!!! Don't even think
        # about it on desktops!!
        "nvme_apple.flush_interval=0"
      ];

      loader = {
        # U-Boot does not support EFI variables
        efi.canTouchEfiVariables = lib.mkForce false;

        # GRUB has to be installed as removable if the user chooses to use it
        grub = lib.mkDefault {
          efiSupport = true;
          efiInstallAsRemovable = true;
          device = "nodev";
        };
      };

      # our kernel config is weird and doesn't really have any modules
      initrd.availableKernelModules = lib.mkForce [ ];

      kernelPackages = pkgs.callPackage ./package.nix {
        crossBuild = config.boot.kernelBuildIsCross;
        _16KBuild = config.boot.kernelBuildIs16K;
      };
    };

    # set a default frequency governor the same way nixos-generate-config does
    # so the necessary bits get properly cross-compiled
    powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

    nixpkgs.overlays = lib.optional config.boot.kernelBuildIs16K (
      self: super: {
        # patch libunwind to work with dynamic pagesizes
        libunwind_fixed_for_16k = super.libunwind.overrideAttrs (o: {
          patches = (o.patches or [ ]) ++ [
            (self.fetchpatch {
              url = "https://github.com/libunwind/libunwind/pull/330.patch";
              hash = "sha256-z3Hpg98D4UMmrE/LC596RFcyxRTvDjD4k7llDPfz1NI=";
            })
          ];
        });
      }
    );

    # sub the fixed libunwind in for the broken copy without triggering
    # horrendous rebuilds
    system.replaceRuntimeDependencies = lib.optionals config.boot.kernelBuildIs16K [
      {
        original = pkgs.libunwind;
        replacement = pkgs.libunwind_fixed_for_16k;
      }
    ];
  };

  options.boot.kernelBuildIsCross = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Set that the Asahi Linux kernel should be cross-compiled.";
  };

  options.boot.kernelBuildIs16K = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = ''
      Set that the Asahi Linux kernel should be built with 16K pages and various
      software patched to be compatible. Some software may still be broken.
    '';
  };
}
