{ config, pkgs, ... }:
let
  configs = {
    x86_64-darwin = import ./x86_64-darwin.nix;
    x86_64-linux = import ./x86_64-linux.nix;
    aarch64-linux = import ./aarch64-linux.nix;
  };
in {
  # Darwin requires application of direnv at system level, linux at user level is fine - TODO fix the below
  services.lorri = { enable = true; };
  environment.systemPackages = with pkgs; [ direnv ];
}
