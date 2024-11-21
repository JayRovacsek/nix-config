{ ... }:
{
  imports = [
    # ./custom-system-preferences.nix
    ./dock.nix
    ./finder.nix
    ./homebrew.nix
    ./keyboard.nix
    ./linux-builder.nix
    ./login-window.nix
    ./networking.nix
    ./ns-global-domain.nix
  ];
}
