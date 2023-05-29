{ lib, ... }:
with lib; {
  options.networking = {
    firewall = mkOption {
      type = with types; anything;
      default = null;
      description = ''
        A darwin stub to primarily ignore the inclusion of 
        networking firewalls values.
      '';
    };
  };
}
