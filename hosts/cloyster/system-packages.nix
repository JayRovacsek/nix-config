{ config, pkgs, ... }: { environment.systemPackages = with pkgs; [ agenix ]; }
