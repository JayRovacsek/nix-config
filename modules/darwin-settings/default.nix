{ pkgs, ... }: {
  imports =
    [ ./documentation.nix ./dock.nix ./homebrew.nix ./nsglobalDomain.nix ];
}
