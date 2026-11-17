{ self, ... }:
{
  imports = [ self.inputs.plasma-manager.homeModules.plasma-manager ];

  # Stylix's KDE target also renders kdeglobals/plasmarc through activation
  # scripts; plasma-manager now owns the Plasma configuration, so hand theming
  # over and let stylix keep only the GTK/Qt sides.
  stylix.targets.kde.enable = false;

  programs.plasma = {
    enable = true;

    # Big Picture is a single-desktop, controller-driven session.
    kwin.virtualDesktops.number = 1;

    session = {
      general.askForConfirmationOnLogout = false;
      sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession";
    };
  };
}
