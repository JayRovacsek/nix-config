{ config, pkgs, ... }:
let
  # Plasma Bigscreen's homescreen resolves its QML imports against the
  # system profile's QML module set (every lib/qt-6/qml path linked from
  # environment.systemPackages), so every module it imports must be
  # installed — even when the host does not use the corresponding service:
  #
  # * org.kde.kdeconnect (indicators/KdeConnect.qml) — provided by
  #   kdeconnect-kde, a runtime dependency of plasma-bigscreen upstream.
  #
  # * org.kde.plasma.networkmanagement (homeoverlay/ColumnActionsRow.qml
  #   and indicators/Wifi.qml) — provided by plasma-nm. This host manages
  #   networking with systemd-networkd + systemd-resolved, but the QML
  #   module is still required by the UI, so plasma-nm is installed
  #   without enabling the NetworkManager service.
  #
  # * org.kde.plasma.private.batterymonitor (PowerManagementItem.qml) —
  #   plasma-workspace 6.8 renamed this module to
  #   org.kde.plasma.private.battery (dropping the InhibitionControl
  #   type), and no package provides the old name, so the file is replaced
  #   with a battery-less stub that keeps the `inhibit` property the
  #   homescreen binds to. Upstream master still carries the broken
  #   import; once a fixed release lands in nixpkgs the override can be
  #   dropped.
  powerManagementItemStub = pkgs.writeText "PowerManagementItem.qml" ''
    /*
        SPDX-FileCopyrightText: 2020 Aditya Mehra <aix.m@outlook.com>
        SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
    */

    import QtQuick

    // Stub replacing the unported upstream file: the real implementation
    // needs org.kde.plasma.private.batterymonitor (removed in Plasma 6.8).
    // The homescreen only binds the `inhibit` property, so keep it inert.
    Item {
        id: powerManagementItem
        property bool inhibit
    }
  '';

  plasma-bigscreen = pkgs.kdePackages.plasma-bigscreen.overrideAttrs (
    final: prev: {
      postPatch = ''
        ${prev.postPatch}

        cp ${powerManagementItemStub} "$(find . -path '*homescreen*' -name PowerManagementItem.qml)"
      '';
    }
  );
in
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
      sessionPackages = [ plasma-bigscreen ];
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
  #
  # kdeconnect-kde and plasma-nm are installed purely to provide the
  # org.kde.kdeconnect and org.kde.plasma.networkmanagement QML modules
  # the homescreen imports (see the comment above the override); neither
  # the KDE Connect daemon nor the NetworkManager service is enabled.
  environment.systemPackages = with pkgs; [
    jellyfin-media-player
    plasma-bigscreen
    retroarch-full
    kdePackages.kdeconnect-kde
    kdePackages.plasma-nm
  ];
}
