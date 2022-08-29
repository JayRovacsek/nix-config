{ config, lib, ... }:
with lib;
let cfg = config.my.flake;
in {
  options.my = {
    flake = mkOption {
      type = with types; anything;
      default = { };
      description = ''
        A value to enable flake recursion.
      '';
    };
  };
}
