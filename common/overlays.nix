{ self }:
let
  inherit (self.common.overlays) system-agnostic darwin linux;
  inherit (self.inputs) nur agenix firefox-darwin;
in {
  all = system-agnostic ++ darwin ++ linux;

  darwin = [ firefox-darwin.overlay ];

  linux = [
    self.overlays.element-desktop
    self.overlays.fcitx-engines
    self.overlays.grub2
    self.overlays.hydra
    self.overlays.makeModulesClosure
    self.overlays.moonlight-wayland
    self.overlays.mpvpaper
    self.overlays.ranger
    self.overlays.sonarr
    self.overlays.waybar
  ];

  system-agnostic = [
    agenix.overlays.default
    nur.overlay
    self.overlays.lib
    self.overlays.nix-monitored
  ];
}
