{ self }: {
  base = import ./base.nix { inherit self; };
  cli = import ./cli.nix { inherit self; };

  # Desktop shares modules with both linux and darwin
  desktop = import ./desktop.nix { inherit self; };

  # Inherit from desktop, then add system specific packages on-top
  darwin-desktop = import ./darwin-desktop.nix { inherit self; };

  # Linux desktop alternatives
  gnome-desktop = import ./gnome-desktop.nix { inherit self; };
  hyprland-desktop = import ./hyprland-desktop.nix { inherit self; };

  # Minimal Linux desktop alternatives
  hyprland-desktop-minimal =
    import ./hyprland-desktop-minimal.nix { inherit self; };
}
