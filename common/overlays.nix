{ self }:
let
  inherit (self.common.overlays) darwin linux system-agnostic;
  inherit (self.inputs)
    agenix
    nur
    ;
in
{
  all = system-agnostic ++ darwin ++ linux;

  darwin = [
    self.overlays.dockutil-bin
    self.overlays.keepassxc
  ];

  linux = [
    self.overlays.element-desktop
    self.overlays.makeModulesClosure
    self.overlays.moonlight-wayland
    self.overlays.mpvpaper
    self.overlays.ranger
    self.overlays.waybar
  ];

  system-agnostic = [
    agenix.overlays.default
    nur.overlays.default
    self.overlays.lib
  ];
}
