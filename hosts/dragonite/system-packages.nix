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
    linuxPackages.nvidia_x11
    lm_sensors
    hddtemp
  ];
}
