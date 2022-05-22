let mode = "dns-server";
in {
  imports = [
    ../../modules/clamav
    ../../modules/fonts
    ../../modules/gnupg
    ../../modules/hardware/raspberry-pi-4
    ../../modules/lorri
    ../../modules/networking
    ../../modules/nix
    ../../modules/openssh
    ../../modules/raspberry-pi/${mode}.nix
    ../../modules/time
    ../../modules/zsh
  ];
}
