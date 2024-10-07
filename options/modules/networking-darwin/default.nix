{ lib, ... }:
with lib;
{
  options.networking = {
    firewall = mkOption {
      type = with types; anything;
      default = null;
      description = ''
        A darwin stub to primarily ignore the inclusion of 
        networking firewalls values.
      '';
    };

    nameservers = mkOption {
      type = with types; listOf str;
      default = [ ];
      description = ''
        A darwin stub to primarily ignore the inclusion of 
        networking firewalls values.
      '';
    };
  };
}
