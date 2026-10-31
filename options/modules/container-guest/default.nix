{ lib, ... }:
{
  options.container-guest.stateBindMounts = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = ''
      Whether the guest's persistent /etc state (machine-id, ssh host keys)
      is provided by bind-mounts from the container host's per-host state
      directory (/var/lib/$HOSTNAME) instead of being built from
      environment.etc. Set by container hosts that synthesise state
      directories; see hosts/dragonite/containers.nix.
    '';
  };
}
