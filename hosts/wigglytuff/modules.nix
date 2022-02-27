with import ../../modules/vlans/dns.nix { interface = "eth0"; }; {
  imports = [
    ../../modules/clamav
    ../../modules/docker
    ../../modules/gnupg
    ../../modules/lsd
    ../../modules/networking
    ../../modules/nix
    ../../modules/openssh
    ../../modules/time
    ../../modules/xfce
    ../../modules/zsh
  ];
}
