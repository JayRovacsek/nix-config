{ config, pkgs, ... }: {
  imports = [
    ../../modules/alacritty
    ../../modules/firefox
    ../../modules/lsd
    ../../modules/starship
    ../../modules/vscodium

    ../../packages/x86_64-darwin.nix
  ];
}
