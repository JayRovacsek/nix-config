{ config, flake, lib }:
let
  microvms = builtins.map (x: flake.nixosConfigurations."${x}")
    (builtins.attrNames config.microvm.vms);

  journaldRules = builtins.map (microvm:
    let
      machineId = microvm.config.systemd.machineId;
      hostName = microvm.config.networking.hostName;
      # creates a symlink of each MicroVM's journal under the host's /var/log/journal
    in "L+ /var/log/journal/${machineId} - - - - /var/lib/microvms/${hostName}/journal/${machineId}")
    (microvms);
in { systemd.tmpfiles.rules = journaldRules; }
