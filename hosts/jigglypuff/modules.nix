let mode = "desktop";
in {
  imports = [
    ../../modules/gnupg
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
