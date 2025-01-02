{
  osConfig,
  ...
}:
let
  stylix-present = builtins.hasAttr "stylix" osConfig;
in
{
  imports = [
    ../../options/home-manager-modules/ghostty
  ];

  programs.ghostty = {
    enable = true;
    settings = {
      "abnormal-command-exit-runtime" = 250;
      "adw-toolbar-style" = "flat";
      "auto-update" = "off";
      "auto-update-channel" = "stable";
      "background-blur-radius" = 20;
      "background-opacity" = 1;
      "bold-is-bright" = true;
      "class" = "com.ghostty-org.ghostty";
      "click-repeat-interval" = 500;
      "clipboard-paste-bracketed-safe" = true;
      "clipboard-paste-protection" = true;
      "clipboard-read" = "allow";
      "clipboard-trim-trailing-spaces" = true;
      "clipboard-write" = "allow";
      "confirm-close-surface" = false;
      "copy-on-select" = true;
      "cursor-click-to-move" = false;
      "desktop-notifications" = true;
      "enquiry-response" = "";
      "font-family" = "Hack Nerd Font";
      "font-family-bold" = "Hack Nerd Font Bold";
      "font-family-bold-italic" = "Hack Nerd Font Bold Italic";
      "font-family-italic" = "Hack Nerd Font Italic";
      "freetype-load-flags" = true;
      "fullscreen" = false;
      "grapheme-width-method" = "unicode";
      "gtk-adwaita" = true;
      "gtk-single-instance" = true;
      "gtk-titlebar" = false;
      "gtk-wide-tabs" = true;
      "image-storage-limit" = 320000000;
      "linux-cgroup" = "always";
      "linux-cgroup-hard-fail" = true;
      "macos-auto-secure-input" = true;
      "macos-titlebar-style" = "hidden";
      "mouse-hide-while-typing" = true;
      "mouse-scroll-multiplier" = 1.0;
      "mouse-shift-capture" = false;
      "osc-color-report-format" = "16-bit";
      "quick-terminal-animation-duration" = 0;
      "quick-terminal-autohide" = false;
      "quick-terminal-position" = "center";
      "quick-terminal-screen" = "main";
      "quit-after-last-window-closed" = "true";
      "quit-after-last-window-closed-delay" = "1s";
      "scrollback-limit" = 50000000;
      "shell-integration" = "detect";
      "shell-integration-features" = true;
      "theme" = if stylix-present then osConfig.stylix.base16Scheme.scheme else "";
      "title" = " ";
      "window-decoration" = false;
      "window-save-state" = "never";
      "window-theme" = "ghostty";
      "window-vsync" = true;
      "window-inherit-working-directory" = true;
      "x11-instance-name" = "ghostty";
    };
  };
}
