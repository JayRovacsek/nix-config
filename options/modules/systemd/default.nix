{ lib, ... }:
with lib;
{
  options.systemd.machineId = mkOption {
    type = types.str;
    # This normally would be generated by systemd, however we really
    # want to set this when using microvms as we want stable machine IDs
    # for journald mounts.
    default = ''
      uninitialized
    '';
    description = ''The machine ID - this needs to be either "uninitialized\n" or a string adhering to: <link xlink:href="https://www.freedesktop.org/software/systemd/man/machine-id.html">systemd machine-id</link>'';
  };
}
