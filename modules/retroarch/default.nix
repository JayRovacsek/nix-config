# Declarative RetroArch. Replaces the inline `retroarch-full` that used to
# live in modules/kde-big-picture: `retroarch-full` bundles every libretro
# core on the platform (including non-free ones), while the plain `retroarch`
# attribute is a bare wrapper with no cores. We standardise on
# `retroarch-bare.wrapper` so the core set and global settings are both
# declarative (retroarch.withCores only forwards cores, not settings).
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.retroarch;

  # Fold the content/system directory options into the matching retroarch.cfg
  # keys so they ride along in the wrapper's --appendconfig. Null entries are
  # dropped so unset directories do not emit empty key = "" lines.
  contentDirKeys = lib.filterAttrs (_: v: v != null) (
    {
      content_directory = cfg.contentDirectories.main;
      content_directory2 = cfg.contentDirectories.secondary;
      rgui_content_directory = cfg.contentDirectories.rgui;
      rgui_browser_directory = cfg.contentDirectories.browser;
    }
    // lib.optionalAttrs (cfg.systemDirectory != null) {
      system_directory = cfg.systemDirectory;
    }
  );
in
{
  imports = [ ../../options/modules/retroarch ];

  config = lib.mkIf cfg.enable {
    # The default is supplied here (not in the options) because R1 gives
    # `package` no default; `cfg.package or …` would throw.
    programs.retroarch.package = lib.mkDefault (
      pkgs.retroarch-bare.wrapper {
        cores = cfg.cores;
        settings = cfg.settings // contentDirKeys;
      }
    );

    environment.systemPackages = [ cfg.package ];

    # Ensure the default content directory exists so the content browser does
    # not point at a missing path.
    systemd.tmpfiles.rules = [ "d /srv/games 0755 root root -" ];
  };
}
