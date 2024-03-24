{ config, lib, self, ... }:
let
  inherit (self.lib.tailscale) lookup-tailnet;
  inherit (config.networking) hostName;

  tailnet = lookup-tailnet hostName;
  authFile = config.age.secrets."preauth-${tailnet}".path;

  headscale-present = config.services.headscale.enable;
in {
  imports = [ ../../options/tailscale ];

  services.tailscale = {
    inherit authFile tailnet;
    enable = true;
  };

  age.secrets."preauth-${tailnet}" = {
    file = ../../secrets/tailscale/preauth-${tailnet}.age;
    mode = if headscale-present then lib.mkForce "0440" else "0400";
    group = if headscale-present then config.services.headscale.group else "0";
  };
}
