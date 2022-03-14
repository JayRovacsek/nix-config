{ config, pkgs, ... }:
let
  nixOverrides = {
    gc.automatic = false;
    optimise.automatic = false;
    settings.auto-optimise-store = false;
  };
  overriddenConfig = import ../../modules/nix {
    pkgs = pkgs;
    overrides = nixOverrides;
  };
in {
  nix = overriddenConfig.nix;

  imports = [
    ../../modules/docker/stacks/dns
    ../../modules/gnupg
    ../../modules/lsd
    ../../modules/networking
    ../../modules/openssh
    ../../modules/time
    ../../modules/zsh
  ];
}
