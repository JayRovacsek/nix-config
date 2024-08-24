{ lib, pkgs, ... }:
{
  home.packages = lib.optionals pkgs.stdenv.isDarwin (with pkgs; [ utm ]);
}
