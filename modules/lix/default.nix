{ self, ... }: {
  nixpkgs.overlays = [ self.overlays.lix ];

  nix.settings = {
    substituters = [ "https://cache.lix.systems" ];
    trusted-public-keys =
      [ "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o=" ];
  };
}
