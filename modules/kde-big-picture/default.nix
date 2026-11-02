{ config, pkgs, ... }:
let
  # Upstream 6.8.1 regressions patched here (all still unfixed upstream):
  #
  # * PowerManagementItem.qml imports org.kde.plasma.private.batterymonitor,
  #   which plasma-workspace 6.8 renamed to org.kde.plasma.private.battery
  #   (dropping the InhibitionControl type), so the homescreen aborts with
  #   "Type PowerManagementItem unavailable". Replaced with a battery-less
  #   stub that keeps the `inhibit` property the homescreen binds to.
  #
  # * homeoverlay/ColumnActionsRow.qml and indicators/Wifi.qml import
  #   org.kde.plasma.networkmanagement (plasma-nm). This host manages
  #   networking with systemd-networkd + systemd-resolved instead of
  #   NetworkManager, so the import is dropped and the Wi-Fi button shows a
  #   static icon.
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

  columnActionsRowStub = pkgs.writeText "ColumnActionsRow.qml" ''
    // SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>
    // SPDX-License-Identifier: GPL-2.0-or-later

    import QtQuick
    import QtQuick.Layouts
    import QtQuick.Controls as QQC2

    import org.kde.kirigami as Kirigami
    import org.kde.bigscreen as Bigscreen
    import org.kde.plasma.plasmoid
    import org.kde.plasma.private.volume

    // NixOS patch: the org.kde.plasma.networkmanagement import (plasma-nm)
    // is removed because this host uses systemd-networkd + systemd-resolved;
    // the Wi-Fi button shows a static icon instead of PlasmaNM.ConnectionIcon.
    RowLayout {
        id: actionsRow
        signal closeRequested()
        signal screenshotRequested()

        Layout.fillWidth: true
        Layout.bottomMargin: Kirigami.Units.largeSpacing

        onActiveFocusChanged: {
            if (activeFocus) {
                screenshotButton.forceActiveFocus();
            }
        }

        Item { Layout.fillWidth: true }

        Bigscreen.Button {
            id: screenshotButton
            flat: true
            icon.name: "view-fullscreen-symbolic"

            QQC2.ToolTip.visible: focus
            QQC2.ToolTip.text: i18n("Screenshot")
            KeyNavigation.right: audioButton

            onClicked: {
                actionsRow.screenshotRequested();
                actionsRow.closeRequested();
            }
        }

        Bigscreen.Button {
            id: audioButton
            flat: true

            QQC2.ToolTip.visible: focus
            QQC2.ToolTip.text: i18n("Audio")
            KeyNavigation.right: wifiButton

            readonly property string dummyOutputName: "auto_null"
            icon.name: PreferredDevice.sink
                && (!isDummyOutput(PreferredDevice.sink)
                    ? AudioIcon.forVolume(volumePercent(PreferredDevice.sink.volume), PreferredDevice.sink.muted, "")
                    : AudioIcon.forVolume(0, true, ""))

            function isDummyOutput(output) {
                return output && output.name === dummyOutputName;
            }

            function volumePercent(volume) {
                return Math.round(volume / PulseAudio.NormalVolume * 100.0);
            }

            onClicked: {
                Plasmoid.openSettings("kcm_mediacenter_audiodevice")
            }
        }

        Bigscreen.Button {
            id: wifiButton
            flat: true
            icon.name: "network-wireless-symbolic"

            QQC2.ToolTip.visible: focus
            QQC2.ToolTip.text: i18n("Wi-Fi")
            KeyNavigation.right: shutdownButton
            onClicked: Plasmoid.openSettings("kcm_mediacenter_wifi")
        }

        Bigscreen.Button {
            id: shutdownButton
            flat: true
            icon.name: Bigscreen.Global.launchReason === "swap" ? "window-close" : "system-shutdown"

            QQC2.ToolTip.visible: focus
            QQC2.ToolTip.text: i18n("Shutdown")

            onClicked: (event)=> {
                if (Bigscreen.Global.launchReason === "swap") {
                    Bigscreen.Global.swapSession();
                } else {
                    // Prompt all since we don't have any other way of doing it.
                    Bigscreen.Global.promptLogoutGreeter("promptAll");
                }
            }
        }

        Item { Layout.fillWidth: true }
    }
  '';

  wifiIndicatorStub = pkgs.writeText "Wifi.qml" ''
    /*
        SPDX-FileCopyrightText: 2019 Marco Martin <mart@kde.org>
        SPDX-FileCopyrightText: 2013-2017 Jan Grulich <jgrulich@redhat.com>

        SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
    */

    import QtQuick
    import QtQuick.Layouts
    import org.kde.plasma.core as PlasmaCore
    import org.kde.plasma.components as PlasmaComponents
    import org.kde.kirigami as Kirigami
    import org.kde.plasma.private.nanoshell as NanoShell
    import org.kde.plasma.plasmoid

    // NixOS patch: org.kde.plasma.networkmanagement (plasma-nm) usage is
    // removed because this host uses systemd-networkd + systemd-resolved;
    // the indicator shows a static icon with no NetworkManager state.
    AbstractIndicator {
        id: connectionIcon
        text: i18n("Internet Settings")
        icon.name: "network-wireless-symbolic"
        onClicked: {
            Plasmoid.openSettings("kcm_mediacenter_wifi")
        }
    }
  '';

  plasma-bigscreen = pkgs.kdePackages.plasma-bigscreen.overrideAttrs (
    final: prev: {
      postPatch = ''
        ${prev.postPatch}

        cp ${powerManagementItemStub} "$(find . -path '*homescreen*' -name PowerManagementItem.qml)"
        cp ${columnActionsRowStub} "$(find . -path '*homeoverlay*' -name ColumnActionsRow.qml)"
        cp ${wifiIndicatorStub} "$(find . -path '*indicators*' -name Wifi.qml)"
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
  environment.systemPackages = with pkgs; [
    jellyfin-media-player
    plasma-bigscreen
    retroarch-full
  ];
}
