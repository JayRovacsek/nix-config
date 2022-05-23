{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    htop

    ## Virtualisation
    docker
    docker-compose
    lima
  ];
}
