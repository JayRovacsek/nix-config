let mode = "dns-server";
in {
  imports = [
    ../../modules/clamav
    ../../modules/fonts
    ../../modules/gnupg
    ../../modules/lorri
    ../../modules/networking
    ../../modules/nix
    ../../modules/openssh
    ../../modules/raspberry-pi/${mode}.nix
    ../../modules/starship
    ../../modules/time
    ../../modules/timesyncd
    ../../modules/zsh
  ];
}
