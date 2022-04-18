{ config, pkgs, ... }: {
  services.lorri = { enable = true; };
  home.packages = with pkgs; [ direnv ];
}
