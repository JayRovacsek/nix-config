{ pkgs, lib, ... }:
let
  enable = with pkgs.stdenv.hostPlatform; !(isLinux && isAarch64);

  packages = lib.optionals enable (with pkgs; [ slack ]);
in
{
  home = {
    inherit packages;
  };

  nixpkgs.config.allowUnfree = true;
}
