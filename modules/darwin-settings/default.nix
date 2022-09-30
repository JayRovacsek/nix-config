{ pkgs, ... }: {
  imports = [
    ./dock.nix
    ./documentation.nix
    ./finder.nix
    ./homebrew.nix
    ./nsglobalDomain.nix
  ];
}
