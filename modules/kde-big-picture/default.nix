{ config, pkgs, ... }:
{
  imports = [
    ../../options/modules/kde-big-picture
    ../steam
  ];

  services = {
    # Plasma 6 desktop environment; provides the KDE session infrastructure
    # and the kwin Wayland compositor that SDDM drives.
    desktopManager.plasma6.enable = true;

    displayManager = {
      # SDDM running natively on Wayland rather than X11. The repo's X11
      # modules/sddm is deliberately not reused here — it would force
      # services.xserver.enable against the Wayland-only intent.
      sddm = {
        enable = true;
        wayland.enable = true;
      };

      # The 10-foot, controller-driven session: registered and made the
      # default, with auto-login for the configured user.
      sessionPackages = [ pkgs.kdePackages.plasma-bigscreen ];
      defaultSession = "plasma-bigscreen-wayland";
      autoLogin = {
        enable = true;
        user = config.kde-big-picture.autoLoginUser;
      };
    };
  };

  # Default Big Picture applications: RetroArch and the Jellyfin desktop
  # client. Steam arrives via the shared steam module imported above.
  #
  # retroarch-full bundles every libretro core available on the platform
  # (including non-free ones); the plain `retroarch` attribute is a bare
  # wrapper with no cores.
  #
  # plasma-bigscreen itself must also be installed in the profile: the
  # session script SDDM launches sources `plasma-bigscreen-common-env`
  # and runs `plasma-bigscreen-envmanager` via bare PATH lookups, while
  # sessionPackages only links the desktop entry, not the package's bin.
  environment.systemPackages = with pkgs; [
    jellyfin-media-player
    kdePackages.plasma-bigscreen
    retroarch-full
  ];
}
