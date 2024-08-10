{ pkgs, lib, ... }:
let
  enable = with pkgs.stdenv; !(isLinux && isAarch64);

  packages = lib.optionals enable (with pkgs; [ slack ]);
in
{
  home = {
    inherit packages;
  };
}
