{
  imports = [
    ../../modules/clamav
    ../../modules/docker
    ../../modules/gnupg
    ../../modules/networking
    ../../modules/nix
    ../../modules/openssh
    ../../modules/time
    ../../modules/vlans/dns.nix
    { interface = "eth0"; }
    ../../modules/xfce
    ../../modules/zsh
  ];
}
