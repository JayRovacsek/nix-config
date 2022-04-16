{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    vim
    wget
    exfat
    cifs-utils
    dnsutils
    curl
    zfs
    htop
    pciutils
    zsh-autosuggestions
    nix-zsh-completions
    jq
    oh-my-zsh
    nvidia-docker
    lm_sensors
    hddtemp
  ];
}
