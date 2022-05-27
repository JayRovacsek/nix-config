{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    agenix
    htop

    ## Virtualisation
    docker
    docker-compose
    lima
  ];
}
