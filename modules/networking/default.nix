{ pkgs, ... }:
let
  configs = {
    x86_64-darwin = import ./x86_64-darwin.nix;
    aarch64-linux = import ./aarch64-linux.nix;
  };
in {
  networking = if pkgs.system != "x86_64-linux" then
    configs.${pkgs.system}
  else {
    useDHCP = false;
    networkmanager.enable = true;
  };
}
