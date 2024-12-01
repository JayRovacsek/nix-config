{
  config,
  lib,
  self,
  ...
}:
let
  cfg = config.remoteBuilds;

  # We use the below value as it'll be available before this
  # evaluates rather than self (which is available but
  # only after further evaluation)
  inherit (self.lib.distributed-builds) base-configs;

  # If enabled but no machine configs exist as a static set, generate
  # them based on flake hosts - note that this is pretty expensive in terms
  # of compute and RAM as it partially evaluates all hosts in a flake.
  #
  # If a flake has less than 5 hosts it's likely fine, but still will likely
  # double build time.
  #
  # To avoid this cost, look at either using the 
  # apps.${system}.generate-distributed-build-configs program
  # Or include these options into a host config, then from the REPL
  # run:
  #
  # > builtins.toFile (builtins.toJSON nixosConfigurations.$HOST.config.nix.buildMachines)
  #
  # Which will provide a path to a suitable file also.

  build-configs =
    if (builtins.typeOf cfg.machineConfigs == "path") then
      builtins.fromJSON (builtins.readFile cfg.machineConfigs)
    else
      base-configs;

  fast-configs = builtins.filter (machine: machine.speedFactor > 1) build-configs;

  key-merged-configs = builtins.map (
    machine: machine // { inherit (cfg) sshKey; }
  ) fast-configs;
in
{
  options.remoteBuilds = {
    enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
    };

    sshKey = lib.mkOption {
      default = null;
      type = with lib.types; nullOr path;
    };

    machineConfigs = lib.mkOption {
      default = null;
      type = with lib.types; nullOr path;
    };
  };

  config = {
    nix.buildMachines = lib.mkIf cfg.enable key-merged-configs;
  };
}
