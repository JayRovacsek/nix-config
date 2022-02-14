{ pkgs, ... }:
let inherit (pkgs.stdenv.hostPlatform) isDarwin;
in {
  networking = if isDarwin then {
    dns = [ "pihole.localdomain" "192.168.6.2" "1.1.1.1" "8.8.8.8" ];
    knownNetworkServices = [ "Wi-Fi" "USB 10/100/1000 LAN" ];
  } else {
    useDHCP = false;
    networkmanager.enable = true;
  };
}
