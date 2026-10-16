{ pkgs, lib, ... }:
{
  services.nextcloud-client = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    enable = true;
    startInBackground = true;
  };
}
