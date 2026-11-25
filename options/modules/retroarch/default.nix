{ lib, pkgs, ... }:
{
  options.programs.retroarch = {
    enable = lib.mkEnableOption "declarative RetroArch";

    # No default here on purpose: the implementing module supplies the
    # package via `mkDefault` (see modules/retroarch). `cfg.package or …`
    # cannot rescue a declared-but-undefined option, so the default must be
    # a real `mkDefault` rather than an `or` fallback.
    package = lib.mkOption {
      type = lib.types.package;
      description = "The RetroArch package to install.";
    };

    cores = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = with pkgs.libretro; [
        nestopia
        snes9x
        swanstation
        mupen64plus
        dolphin
        mgba
        gambatte
        melonds
      ];
      description = "Libretro cores bundled into the RetroArch wrapper.";
    };

    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = ''
        Arbitrary global retroarch.cfg keys, baked into the wrapper via
        --appendconfig. Values must be strings.
      '';
    };

    contentDirectories = {
      main = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = "/srv/games";
        description = "content_directory.";
      };
      secondary = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "content_directory2.";
      };
      rgui = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "rgui_content_directory.";
      };
      browser = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "rgui_browser_directory.";
      };
    };

    systemDirectory = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "system_directory (BIOS location).";
    };

    perCoreOptions = lib.mkOption {
      type = lib.types.attrsOf (lib.types.attrsOf lib.types.str);
      default = { };
      description = ''
        Core-internal option keys, keyed by core display name. These belong
        in a writable config/<Core>/<Game>-core-options.cfg, so they are
        consumed by the home-manager module rather than the global cfg.
      '';
    };

    coreOverrides = lib.mkOption {
      type = lib.types.attrsOf (lib.types.attrsOf lib.types.str);
      default = { };
      description = ''
        Per-core override keys, keyed by core display name. These belong in a
        writable config/<Core>/<Core>.cfg, so they are consumed by the
        home-manager module rather than the global cfg.
      '';
    };
  };
}
