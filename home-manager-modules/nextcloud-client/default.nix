{ pkgs, lib, ... }:
{
  services.nextcloud-client = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    startInBackground = true;
  };
}
