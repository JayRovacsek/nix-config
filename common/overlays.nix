{ self }:
let
  inherit (self.common.overlays) darwin linux system-agnostic;
  inherit (self.inputs) agenix firefox-darwin nur;
in {
  all = system-agnostic ++ darwin ++ linux;

  darwin = [
    firefox-darwin.overlay
    self.overlays.dockutil-bin
    self.overlays.keepassxc
  ];

  linux = [
    self.overlays.element-desktop
    self.overlays.fcitx-engines
    self.overlays.jellyfin-wayland
    self.overlays.makeModulesClosure
    self.overlays.moonlight-wayland
    self.overlays.mpvpaper
    self.overlays.ranger
    self.overlays.waybar
  ];

  system-agnostic = [ agenix.overlays.default nur.overlay self.overlays.lib ];
}
