{ config, lib, ... }:
with lib; {
  options.recursive.config = mkOption {
    type = with types; anything;
    default = { };
    description = ''
      A value to enable config recursion. Note that it is possible to reference 
      config already, however will cause infinite recursion where the config value
      is also set where referenced.
    '';
  };

  options.recursive.flake = mkOption {
    type = with types; anything;
    default = { };
    description = ''
      A value to enable flake recursion.
    '';
  };
}
