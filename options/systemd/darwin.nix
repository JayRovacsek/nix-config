{ lib, ... }:
with lib; {
  options.systemd = mkOption {
    type = with types; anything;
    default = null;
    description = ''
      A darwin stub to primarily ignore the inclusion of 
      systemd values.
    '';
  };
}
