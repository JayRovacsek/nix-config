{ self }:
let inherit (self.common.home-manager-module-sets) hyprland-desktop;
in hyprland-desktop ++ (with self.homeManagerModules; [ ags mopidy ])
++ [ self.inputs.ags.homeManagerModules.default ]
