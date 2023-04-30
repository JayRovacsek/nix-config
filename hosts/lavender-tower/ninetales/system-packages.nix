{ pkgs, ... }: { environment.systemPackages = with pkgs; [ htop git ]; }
