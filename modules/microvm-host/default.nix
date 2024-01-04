{ config, lib, ... }:
let
  inherit (config) flake;
  inherit (flake.lib.microvm) is-microvm-host;

  enable = is-microvm-host config;

  microvmHostnames =
    if enable then (builtins.attrNames config.microvm.vms) else [ ];

  # Assumption vms value matches that of a nixosConfiguration
  # TODO: add guard to check for attribute
  microvms =
    builtins.map (x: flake.nixosConfigurations."${x}") microvmHostnames;

  journaldRules = builtins.map (microvm:
    let
      inherit (microvm.config.systemd) machineId;
      inherit (microvm.config.networking) hostName;
      # creates a symlink of each MicroVM's journal under the host's /var/log/journal
    in "L+ /var/log/journal/${machineId} - - - - /var/lib/microvms/${hostName}/journal/${machineId}")
    microvms;

in {
  imports = [ ../systemd-networkd ../../options/microvm-host ];

  nix.settings = {
    substituters = [ "https://microvm.cachix.org/" ];
    trusted-public-keys =
      [ "microvm.cachix.org-1:oXnBc6hRE3eX5rSYdRyMYXnfzcCxC7yKPTbZXALsqys=" ];
  };

  systemd.tmpfiles.rules = journaldRules;
}
