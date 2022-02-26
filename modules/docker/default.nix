{ pkgs, ... }:
let configs = { aarch64-linux = import ./aarch64-linux.nix; };
in {
  virtualisation.docker = if pkgs.system != "x86_64-linux" then
    configs.${pkgs.system}
  else {
    enable = true;
    enableNvidia = true;
    rootless.enable = true;
    autoPrune.enable = true;
  };
}
