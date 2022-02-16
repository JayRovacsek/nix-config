# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/calculator" = {
      accuracy = 9;
      angle-units = "degrees";
      base = 10;
      button-mode = "basic";
      number-format = "automatic";
      show-thousands = false;
      show-zeroes = false;
      source-currency = "";
      source-units = "degree";
      target-currency = "";
      target-units = "radian";
      window-position = mkTuple [ 964 64 ];
      word-size = 64;
    };

    "org/gnome/control-center" = { last-panel = "keyboard"; };

    "org/gnome/desktop/input-sources" = {
      per-window = false;
      sources = [ (mkTuple [ "xkb" "us" ]) ];
      xkb-options = [ "terminate:ctrl_alt_bksp" "lv3:ralt_switch" ];
    };

    "org/gnome/desktop/interface" = {
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      gtk-im-module = "gtk-im-context-simple";
      gtk-theme = "Adwaita-dark";
      icon-theme = "hicolor";
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
        "ca-desrt-dconf-editor"
      ];
      show-banners = true;
    };

    "org/gnome/desktop/notifications/application/alacritty" = {
      application-id = "Alacritty.desktop";
    };

    "org/gnome/desktop/notifications/application/ca-desrt-dconf-editor" = {
      application-id = "ca.desrt.dconf-editor.desktop";
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

    "org/gnome/desktop/notifications/application/zoom" = {
      application-id = "Zoom.desktop";
    };

    "org/gnome/desktop/peripherals/keyboard" = { numlock-state = true; };

    "org/gnome/desktop/peripherals/touchpad" = {
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/privacy" = { disable-microphone = false; };

    "org/gnome/desktop/search-providers" = {
      sort-order = [
        "org.gnome.Contacts.desktop"
        "org.gnome.Documents.desktop"
        "org.gnome.Nautilus.desktop"
      ];
    };

    "org/gnome/desktop/sound" = {
      event-sounds = true;
      theme-name = "__custom";
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

    "org/gnome/nm-applet/eap/d7c1d2f9-0fa9-3f45-9067-651eb66d13b2" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
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
      disable-user-extensions = false;
      disabled-extensions = [
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "screenshot-window-sizer@gnome-shell-extensions.gcampax.github.com"
        "improved-workspace-indicator@michaelaquilina.github.io"
      ];
      enabled-extensions = [
        "gnome-shell-screenshot@ttll.de"
        "caffeine@patapon.info"
        "dash-to-panel@jderose9.github.com"
        "blur-my-shell@aunetx"
        "notification-banner-reloaded@marcinjakubowski.github.com"
        "pop-shell@system76.com"
        "sensory-perception@HarlemSquirrel.github.io"
      ];
      favorite-apps = [
        "Alacritty.desktop"
        "org.gnome.Nautilus.desktop"
        "code.desktop"
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

    "org/gnome/shell/extensions/custom-hot-corners-extended/monitor-0-top-left-0" =
      {
        action = "disabled";
      };

    "org/gnome/shell/extensions/custom-hot-corners-extended/monitor-0-top-left-1" =
      {
        action = "disabled";
      };

    "org/gnome/shell/extensions/custom-hot-corners-extended/monitor-0-top-left-2" =
      {
        action = "disabled";
      };

    "org/gnome/shell/extensions/custom-hot-corners-extended/monitor-0-top-left-3" =
      {
        action = "disabled";
      };

    "org/gnome/shell/extensions/custom-hot-corners-extended/monitor-0-top-left-4" =
      {
        action = "disabled";
      };

    "org/gnome/shell/extensions/custom-hot-corners-extended/monitor-0-top-left-5" =
      {
        action = "disabled";
      };

    "org/gnome/shell/extensions/dash-to-panel" = {
      animate-app-switch = true;
      animate-appicon-hover = true;
      animate-appicon-hover-animation-convexity =
        "{'RIPPLE': 2.0, 'PLANK': 1.0, 'SIMPLE': 0.0}";
      animate-appicon-hover-animation-duration =
        "{'SIMPLE': uint32 160, 'RIPPLE': 130, 'PLANK': 100}";
      animate-appicon-hover-animation-extent =
        "{'RIPPLE': 4, 'PLANK': 4, 'SIMPLE': 1}";
      animate-appicon-hover-animation-rotation =
        "{'SIMPLE': 0, 'RIPPLE': 10, 'PLANK': 0}";
      animate-appicon-hover-animation-travel =
        "{'SIMPLE': 0.29999999999999999, 'RIPPLE': 0.40000000000000002, 'PLANK': 0.0}";
      animate-appicon-hover-animation-type = "SIMPLE";
      animate-appicon-hover-animation-zoom =
        "{'SIMPLE': 1.0, 'RIPPLE': 1.25, 'PLANK': 2.0}";
      animate-window-launch = true;
      appicon-margin = 8;
      appicon-padding = 4;
      available-monitors = [ 1 0 ];
      desktop-line-use-custom-color = false;
      dot-color-1 = "#5294e2";
      dot-color-2 = "#5294e2";
      dot-color-3 = "#5294e2";
      dot-color-4 = "#5294e2";
      dot-color-dominant = false;
      dot-color-override = false;
      dot-color-unfocused-1 = "#5294e2";
      dot-color-unfocused-2 = "#5294e2";
      dot-color-unfocused-3 = "#5294e2";
      dot-color-unfocused-4 = "#5294e2";
      dot-color-unfocused-different = false;
      dot-position = "RIGHT";
      dot-size = 3;
      dot-style-focused = "DOTS";
      dot-style-unfocused = "DOTS";
      focus-highlight = true;
      focus-highlight-color = "#EEEEEE";
      focus-highlight-dominant = false;
      focus-highlight-opacity = 25;
      group-apps = true;
      hide-overview-on-startup = false;
      hotkeys-overlay-combo = "TEMPORARILY";
      intellihide = true;
      intellihide-animation-time = 200;
      intellihide-behaviour = "ALL_WINDOWS";
      intellihide-close-delay = 400;
      intellihide-enable-start-delay = 2000;
      intellihide-hide-from-windows = true;
      intellihide-key-toggle-text = "<Super>i";
      intellihide-only-secondary = false;
      intellihide-pressure-threshold = 100;
      intellihide-pressure-time = 1000;
      intellihide-show-in-fullscreen = false;
      intellihide-use-pressure = false;
      isolate-workspaces = false;
      leftbox-padding = -1;
      middle-click-action = "LAUNCH";
      panel-anchors = ''
        {"0":"START","1":"START","2":"START","3":"START"}\n
      '';
      panel-element-positions = ''
        {"0":[{"element":"showAppsButton","visible":true,"position":"centered"},{"element":"activitiesButton","visible":false,"position":"stackedTL"},{"element":"leftBox","visible":false,"position":"stackedTL"},{"element":"taskbar","visible":true,"position":"centered"},{"element":"centerBox","visible":false,"position":"stackedBR"},{"element":"rightBox","visible":false,"position":"stackedBR"},{"element":"dateMenu","visible":false,"position":"stackedBR"},{"element":"systemMenu","visible":false,"position":"stackedBR"},{"element":"desktopButton","visible":false,"position":"stackedBR"}],"1":[{"element":"showAppsButton","visible":true,"position":"centered"},{"element":"activitiesButton","visible":false,"position":"stackedTL"},{"element":"leftBox","visible":false,"position":"stackedTL"},{"element":"taskbar","visible":true,"position":"centered"},{"element":"centerBox","visible":false,"position":"stackedBR"},{"element":"rightBox","visible":false,"position":"stackedBR"},{"element":"dateMenu","visible":false,"position":"stackedBR"},{"element":"systemMenu","visible":false,"position":"stackedBR"},{"element":"desktopButton","visible":false,"position":"stackedBR"}],"2":[{"element":"showAppsButton","visible":true,"position":"centered"},{"element":"activitiesButton","visible":false,"position":"stackedTL"},{"element":"leftBox","visible":false,"position":"stackedTL"},{"element":"taskbar","visible":true,"position":"centered"},{"element":"centerBox","visible":false,"position":"stackedBR"},{"element":"rightBox","visible":false,"position":"stackedBR"},{"element":"dateMenu","visible":false,"position":"stackedBR"},{"element":"systemMenu","visible":false,"position":"stackedBR"},{"element":"desktopButton","visible":false,"position":"stackedBR"}],"3":[{"element":"showAppsButton","visible":true,"position":"centered"},{"element":"activitiesButton","visible":false,"position":"stackedTL"},{"element":"leftBox","visible":false,"position":"stackedTL"},{"element":"taskbar","visible":true,"position":"centered"},{"element":"centerBox","visible":false,"position":"stackedBR"},{"element":"rightBox","visible":false,"position":"stackedBR"},{"element":"dateMenu","visible":false,"position":"stackedBR"},{"element":"systemMenu","visible":false,"position":"stackedBR"},{"element":"desktopButton","visible":false,"position":"stackedBR"}]}\n
      '';
      panel-element-positions-monitors-sync = true;
      panel-lengths = ''
        {"0":100,"1":100,"2":100,"3":100}\n
      '';
      panel-positions = ''
        {"0":"LEFT","1":"LEFT","2":"LEFT","3":"LEFT"}\n
      '';
      panel-sizes = ''
        {"0":48,"1":48,"2":48,"3":48}\n
      '';
      primary-monitor = 3;
      secondarymenu-contains-showdetails = false;
      shift-click-action = "MINIMIZE";
      shift-middle-click-action = "LAUNCH";
      show-appmenu = false;
      show-apps-icon-file = "";
      show-apps-icon-side-padding = 0;
      show-apps-override-escape = true;
      show-favorites-all-monitors = true;
      show-running-apps = true;
      show-showdesktop-delay = 1000;
      show-showdesktop-hover = false;
      show-showdesktop-time = 300;
      showdesktop-button-width = 8;
      status-icon-padding = -1;
      stockgs-force-hotcorner = true;
      stockgs-keep-dash = false;
      stockgs-keep-top-panel = true;
      stockgs-panelbtn-click-only = false;
      trans-bg-color = "#000000";
      trans-panel-opacity = 0.0;
      trans-use-custom-bg = false;
      trans-use-custom-gradient = false;
      trans-use-custom-opacity = true;
      trans-use-dynamic-opacity = false;
      tray-padding = -1;
      tray-size = 64;
      window-preview-title-position = "TOP";
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

    "org/gtk/gtk4/settings/file-chooser" = {
      date-format = "regular";
      location-mode = "path-bar";
      show-hidden = false;
      show-size-column = true;
      show-type-column = true;
      sidebar-width = 167;
      sort-column = "name";
      sort-directories-first = false;
      sort-order = "ascending";
      type-format = "category";
      window-size = mkTuple [ 986 431 ];
    };

    "org/gtk/settings/file-chooser" = {
      date-format = "regular";
      location-mode = "path-bar";
      show-hidden = false;
      show-size-column = true;
      show-type-column = true;
      sidebar-width = 157;
      sort-column = "modified";
      sort-directories-first = false;
      sort-order = "descending";
      type-format = "category";
      window-position = mkTuple [ 2760 78 ];
      window-size = mkTuple [ 1080 902 ];
    };

    "org/virt-manager/virt-manager" = {
      manager-window-height = 550;
      manager-window-width = 550;
    };

    "org/virt-manager/virt-manager/confirm" = {
      forcepoweroff = false;
      unapplied-dev = true;
    };

    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///session" ];
      uris = [ "qemu:///session" ];
    };

    "org/virt-manager/virt-manager/details" = { show-toolbar = true; };

    "org/virt-manager/virt-manager/paths" = {
      media-default = "/home/jay/Downloads";
    };

    "org/virt-manager/virt-manager/urls" = {
      isos = [
        "/home/jay/Downloads/OPNsense-21.7.1-OpenSSL-dvd-amd64.iso"
        "/home/jay/temp/x86_64/bsd/opnsense/OPNsense-21.7.1-OpenSSL-vga-amd64.img.bz2"
      ];
    };

    "org/virt-manager/virt-manager/vmlist-fields" = {
      disk-usage = false;
      network-traffic = false;
    };

    "org/virt-manager/virt-manager/vms/4b4512e7ba5845de9d3b3b9a227ab8bf" = {
      autoconnect = 1;
      scaling = 1;
      vm-window-size = mkTuple [ 1024 810 ];
    };

  };
}
