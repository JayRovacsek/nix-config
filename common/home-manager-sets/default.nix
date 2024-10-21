{ self }:
{
  ai = import ./ai.nix { inherit self; };
  base = import ./base.nix { inherit self; };
  cli = import ./cli.nix { inherit self; };
  games = import ./games.nix { inherit self; };
  impermanence = import ./impermanence.nix { inherit self; };

  # Desktop shares modules with both linux and darwin
  desktop-minimal = import ./desktop-minimal.nix { inherit self; };
  desktop = import ./desktop.nix { inherit self; };

  # Inherit from desktop, then add system specific packages on-top
  darwin-desktop = import ./darwin-desktop.nix { inherit self; };

  # Linux desktop alternatives
  gnome-desktop = import ./gnome-desktop.nix { inherit self; };
  hyprland-desktop = import ./hyprland-desktop.nix { inherit self; };
  hyprland-ironbar-desktop = import ./hyprland-ironbar-desktop.nix {
    inherit self;
  };
  hyprland-waybar-desktop = import ./hyprland-waybar-desktop.nix {
    inherit self;
  };

  # Minimal Linux desktop alternatives
  hyprland-desktop-minimal = import ./hyprland-desktop-minimal.nix {
    inherit self;
  };

  # Linux desktop + games
  hyprland-games-desktop =
    self.common.home-manager-module-sets.hyprland-desktop
    ++ self.common.home-manager-module-sets.games;

  ssh = [ self.homeManagerModules.ssh ];
}
