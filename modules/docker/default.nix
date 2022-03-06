{ pkgs, ... }:
let
  configs = {
    aarch64-linux = import ./aarch64-linux.nix;
    x86_64-linux = import ./x86_64-linux.nix;
  };
in { virtualisation.docker = configs.${pkgs.system}; }
