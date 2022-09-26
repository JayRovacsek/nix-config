{ pkgs }: {
  oh-my-custom = pkgs.callPackage ./oh-my-custom { };
  pokemmo = pkgs.callPackage ./pokemmo { };
}
