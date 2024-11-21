{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ nix-monitored ];
}
