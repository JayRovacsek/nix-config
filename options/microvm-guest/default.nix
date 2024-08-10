{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  mac = mkOption {
    # type = types.net.mac;
    type = types.str;
    description = "The base mac address from which the guest's mac will be derived. Only the second and third byte are used, so for 02:XX:YY:ZZ:ZZ:ZZ, this specifies XX and YY, while Zs are generated automatically. Not used if the mac is set directly.";
    default = "02:01:27:00:00:00";
  };

  macvtap = mkOption {
    type = types.str;
    description = "The host interface to which the microvm should be attached via macvtap";
  };
}
