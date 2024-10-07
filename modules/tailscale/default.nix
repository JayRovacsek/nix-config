{ config, lib, ... }:
let
  headscale-present = config.services.headscale.enable;

  preauth-key-defined = builtins.hasAttr "tailnet-preauth" config.age.secrets;
in
{
  age.secrets.tailnet-preauth = {
    mode = lib.mkIf preauth-key-defined (
      if headscale-present then lib.mkForce "0440" else "0400"
    );
    group = lib.mkIf preauth-key-defined (
      if headscale-present then config.services.headscale.group else "0"
    );
  };

  networking.nameservers = [ "100.100.100.100" ];

  services.tailscale = {
    enable = true;
    authKeyFile = config.age.secrets.tailnet-preauth.path;
  };
}
