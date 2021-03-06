# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      gtk-im-module = "gtk-im-context-simple";
      gtk-theme = "Adwaita-dark";
      icon-theme = "Adwaita";
    };

    "org/gnome/desktop/notifications" = {
      application-children = [
        "gnome-power-panel"
        "firefox"
        "org-keepassxc-keepassxc"
        "signal-desktop"
        "discord"
        "thunderbird"
        "alacritty"
        "org-gnome-nautilus"
        "gnome-network-panel"
        "slack"
        "com-nextcloud-desktopclient-nextcloud"
        "steam"
        "gnome-control-center"
        "zoom"
        "gimp"
      ];
      show-banners = true;
    };

    "org/gnome/desktop/notifications/application/alacritty" = {
      application-id = "Alacritty.desktop";
    };

    "org/gnome/desktop/notifications/application/com-nextcloud-desktopclient-nextcloud" =
      {
        application-id = "com.nextcloud.desktopclient.nextcloud.desktop";
      };

    "org/gnome/desktop/notifications/application/discord" = {
      application-id = "discord.desktop";
    };

    "org/gnome/desktop/notifications/application/firefox" = {
      application-id = "firefox.desktop";
    };

    "org/gnome/desktop/notifications/application/gimp" = {
      application-id = "gimp.desktop";
    };

    "org/gnome/desktop/notifications/application/gnome-control-center" = {
      application-id = "gnome-control-center.desktop";
    };

    "org/gnome/desktop/notifications/application/gnome-network-panel" = {
      application-id = "gnome-network-panel.desktop";
    };

    "org/gnome/desktop/notifications/application/gnome-power-panel" = {
      application-id = "gnome-power-panel.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-nautilus" = {
      application-id = "org.gnome.Nautilus.desktop";
    };

    "org/gnome/desktop/notifications/application/org-keepassxc-keepassxc" = {
      application-id = "org.keepassxc.KeePassXC.desktop";
    };

    "org/gnome/desktop/notifications/application/runelite" = {
      application-id = "RuneLite.desktop";
    };

    "org/gnome/desktop/notifications/application/signal-desktop" = {
      application-id = "signal-desktop.desktop";
    };

    "org/gnome/desktop/notifications/application/slack" = {
      application-id = "slack.desktop";
    };

    "org/gnome/desktop/notifications/application/steam" = {
      application-id = "steam.desktop";
    };

    "org/gnome/desktop/notifications/application/thunderbird" = {
      application-id = "thunderbird.desktop";
    };

    "org/gnome/desktop/peripherals/keyboard" = { numlock-state = true; };

    "org/gnome/desktop/peripherals/touchpad" = {
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/privacy" = { disable-microphone = false; };

    "org/gnome/desktop/search-providers" = {
      sort-order = [ "org.gnome.Nautilus.desktop" ];
    };

    "org/gnome/desktop/sound" = {
      event-sounds = true;
      theme-name = "freedesktop";
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
    };

    "org/gnome/eog/view" = {
      background-color = "rgb(0,0,0)";
      use-background-color = true;
    };

    "org/gnome/evolution-data-server" = {
      migrated = true;
      network-monitor-gio-name = "";
    };

    "org/gnome/file-roller/dialogs/extract" = {
      recreate-folders = true;
      skip-newer = false;
    };

    "org/gnome/file-roller/listing" = {
      list-mode = "as-folder";
      name-column-width = 250;
      show-path = false;
      sort-method = "name";
      sort-type = "ascending";
    };

    "org/gnome/file-roller/ui" = {
      sidebar-width = 200;
      window-height = 480;
      window-width = 600;
    };

    "org/gnome/gnome-screenshot" = {
      delay = 0;
      include-pointer = false;
      last-save-directory = "file:///home/jay/Pictures";
    };

    "org/gnome/mutter" = {
      attach-modal-dialogs = true;
      dynamic-workspaces = true;
      edge-tiling = true;
      focus-change-on-pointer-rest = true;
      workspaces-only-on-primary = true;
    };

    "org/gnome/nautilus/list-view" = { default-zoom-level = "standard"; };

    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "icon-view";
      search-filter-time-type = "last_modified";
      search-view = "list-view";
    };

    "org/gnome/nautilus/window-state" = {
      initial-size = mkTuple [ 673 327 ];
      maximized = false;
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" =
      {
        binding = "<Primary><Shift>space";
        command = "rofi -show drun";
        name = "Rofi Launch";
      };

    "org/gnome/shell" = {
      app-picker-layout =
        "[{'org.gnome.clocks.desktop': <{'position': <0>}>, 'org.gnome.Calculator.desktop': <{'position': <1>}>, 'org.gnome.FileRoller.desktop': <{'position': <2>}>, 'org.gnome.Calendar.desktop': <{'position': <3>}>, 'simple-scan.desktop': <{'position': <4>}>, 'chromium-browser.desktop': <{'position': <5>}>, 'gnome-control-center.desktop': <{'position': <6>}>, 'ca.desrt.dconf-editor.desktop': <{'position': <7>}>, 'gnome-system-monitor.desktop': <{'position': <8>}>, 'discord.desktop': <{'position': <9>}>, 'org.gnome.baobab.desktop': <{'position': <10>}>, 'org.gnome.Terminal.desktop': <{'position': <11>}>, 'org.gnome.DiskUtility.desktop': <{'position': <12>}>, 'org.gnome.Extensions.desktop': <{'position': <13>}>, 'gimp.desktop': <{'position': <14>}>, 'yelp.desktop': <{'position': <15>}>, 'htop.desktop': <{'position': <16>}>, 'org.gnome.Screenshot.desktop': <{'position': <17>}>, 'org.gnome.eog.desktop': <{'position': <18>}>, 'com.github.iwalton3.jellyfin-media-player.desktop': <{'position': <19>}>, 'org.gnome.font-viewer.desktop': <{'position': <20>}>, 'startcenter.desktop': <{'position': <21>}>, 'base.desktop': <{'position': <22>}>, 'calc.desktop': <{'position': <23>}>}, {'draw.desktop': <{'position': <0>}>, 'impress.desktop': <{'position': <1>}>, 'math.desktop': <{'position': <2>}>, 'writer.desktop': <{'position': <3>}>, 'org.gnome.Logs.desktop': <{'position': <4>}>, 'cups.desktop': <{'position': <5>}>, 'com.nextcloud.desktopclient.nextcloud.desktop': <{'position': <6>}>, 'nixos-manual.desktop': <{'position': <7>}>, 'nvidia-settings.desktop': <{'position': <8>}>, 'org.gnome.seahorse.Application.desktop': <{'position': <9>}>, 'org.polymc.PolyMC.desktop': <{'position': <10>}>, 'redshift-gtk.desktop': <{'position': <11>}>, 'steam.desktop': <{'position': <12>}>, 'thunderbird.desktop': <{'position': <13>}>, 'org.gnome.Tour.desktop': <{'position': <14>}>, 'org.gnome.tweaks.desktop': <{'position': <15>}>, 'Unrailed!.desktop': <{'position': <16>}>, 'org.wireshark.Wireshark.desktop': <{'position': <17>}>, 'xterm.desktop': <{'position': <18>}>, 'ykman-gui.desktop': <{'position': <19>}>}]";
      disable-user-extensions = false;
      disabled-extensions = [
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "screenshot-window-sizer@gnome-shell-extensions.gcampax.github.com"
        "improved-workspace-indicator@michaelaquilina.github.io"
        "apps-menu@gnome-shell-extensions.gcampax.github.com"
        "auto-move-windows@gnome-shell-extensions.gcampax.github.com"
        "places-menu@gnome-shell-extensions.gcampax.github.com"
        "native-window-placement@gnome-shell-extensions.gcampax.github.com"
      ];
      enabled-extensions = [
        "gnome-shell-screenshot@ttll.de"
        "caffeine@patapon.info"
        "blur-my-shell@aunetx"
        "notification-banner-reloaded@marcinjakubowski.github.com"
        "pop-shell@system76.com"
        "dash-to-panel@jderose9.github.com"
      ];
      favorite-apps = [
        "Alacritty.desktop"
        "codium.desktop"
        "org.gnome.Nautilus.desktop"
        "firefox.desktop"
        "org.keepassxc.KeePassXC.desktop"
        "signal-desktop.desktop"
        "slack.desktop"
        "RuneLite.desktop"
      ];
      welcome-dialog-last-shown-version = "40.1";
    };

    "org/gnome/shell/extensions/blur-my-shell" = {
      appfolder-dialog-opacity = 0.51;
      brightness = 0.6;
      dash-opacity = 1.0;
      debug = false;
      hacks-level = 1;
      hidetopbar = false;
      sigma = 30;
    };

    "org/gnome/shell/extensions/caffeine" = {
      nightlight-control = "never";
      user-enabled = true;
    };

    "org/gnome/shell/extensions/pop-shell" = {
      active-hint = true;
      gap-inner = mkUint32 2;
      gap-outer = mkUint32 2;
      smart-gaps = true;
      snap-to-grid = true;
      tile-by-default = true;
    };

    "org/gnome/shell/extensions/screenshot" = {
      capture-delay = 0;
      click-action = "show-menu";
      clipboard-action = "none";
      copy-button-action = "set-image-data";
      effect-rescale = 100;
      save-screenshot = true;
    };

    "org/gnome/shell/extensions/sensory-perception" = {
      display-decimal-value = true;
      display-label = true;
      main-sensor = "Average";
      unit = "Centigrade";
      update-time = 15;
    };

    "org/gnome/shell/world-clocks" = { locations = "@av []"; };

    "org/gnome/tweaks" = { show-extensions-notice = false; };
  };
}
