{ ... }: {
  imports = [
    # ./custom-system-preferences.nix
    ./dock.nix
    ./documentation.nix
    ./finder.nix
    ./homebrew.nix
    ./keyboard.nix
    ./login-window.nix
    ./networking.nix
    ./ns-global-domain.nix
  ];
}
