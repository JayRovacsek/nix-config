{ pkgs, ... }: {
  imports = [
    ./dock.nix
    ./documentation.nix
    ./finder.nix
    ./homebrew.nix
    ./login-window.nix
    ./ns-global-domain.nix
  ];
}
