{ config, pkgs, lib, ... }: {
  imports = [
    ../../modules/clamav
    ../../modules/lorri
    ../../modules/nix
    ../../modules/openssh
    ../../modules/time
    ../../modules/timesyncd
    ../../modules/zsh
  ];
}
