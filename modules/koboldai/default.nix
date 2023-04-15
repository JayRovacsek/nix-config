{ config, pkgs, lib, ... }:
let
  inherit (pkgs) system;
  inherit (config.flake.inputs.nixified-ai.packages.${system}) koboldai-nvidia;
  nvidiaPresent = builtins.any (driver: driver == "nvidia")
    config.services.xserver.videoDrivers;

in {
  # TODO: write this into a basic systemd module; that way we can run it as
  # a service on a remote host pretty nicely
  environment.systemPackages = lib.optional nvidiaPresent koboldai-nvidia;

  networking.firewall = { allowedTCPPorts = [ 5000 ]; };

  nix.settings = {
    substituters = [ "https://ai.cachix.org/" ];
    trusted-public-keys =
      [ "ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc=" ];
  };
}
