{ config, lib, self, ... }:
let
  inherit (self.lib.microvm) is-microvm-host;

  path-file = s: lib.last (lib.splitString "/" s);

  enable = is-microvm-host config;

  microvmHostnames =
    if enable then (builtins.attrNames config.microvm.vms) else [ ];

  # Assumption vms value matches that of a nixosConfiguration
  # TODO: add guard to check for attribute
  microvms = builtins.map (x: self.nixosConfigurations.${x}) microvmHostnames;

  agenix-rules = builtins.foldl' (acc: microvm:
    acc ++ (builtins.map (y:
      "C /agenix/${microvm.config.systemd.machineId}/${
        path-file y
      } - - - - ${y}") microvm.config.age.identityPaths)) [ ] microvms;

  journald-rules = builtins.map (microvm:
    let
      inherit (microvm.config.systemd) machineId;
      inherit (microvm.config.networking) hostName;
      # creates a symlink of each MicroVM's journal under the host's /var/log/journal
    in "L+ /var/log/journal/${machineId} - - - - /var/lib/microvms/${hostName}/journal/${machineId}")
    microvms;

in {
  imports = [
    self.inputs.microvm.nixosModules.host
    ../systemd-networkd
    ../../options/microvm-host
  ];

  nix.settings = {
    substituters = [ "https://microvm.cachix.org/" ];
    trusted-public-keys =
      [ "microvm.cachix.org-1:oXnBc6hRE3eX5rSYdRyMYXnfzcCxC7yKPTbZXALsqys=" ];
  };

  systemd.tmpfiles.rules = agenix-rules ++ journald-rules;
}
