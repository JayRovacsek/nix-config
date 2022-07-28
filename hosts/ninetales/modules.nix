{ config, pkgs, ... }: {
  imports = [
    ../../modules/dockutil
    ../../modules/documentation
    ../../modules/fonts
    ../../modules/gnupg
    ../../modules/homebrew
    ../../modules/lorri
    ../../modules/networking
    (import ../../modules/nix {
      inherit config;
      arch = "aarch64-darwin";
    })
    ../../modules/time
    ../../modules/yabai
    ../../modules/zsh
  ];
}
