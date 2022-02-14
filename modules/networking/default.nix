{ pkgs, ... }:
let inherit (pkgs.stdenv.hostPlatform) isDarwin;
in {
  networking = if isDarwin then {
    dns = [ "1.1.1.1" "8.8.8.8" ];
  } else {
    useDHCP = false;
    networkmanager.enable = true;
  };
}
