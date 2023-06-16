{ config, lib, ... }:
let
  inherit (config.flake.lib.tailscale) lookup-tailnet;
  inherit (config.networking) hostName;

  tailnet = lookup-tailnet hostName;
  authFile = config.age.secrets."preauth-${tailnet}".path;
in {
  imports = [ ../../options/tailscale ];

  services.tailscale = {
    inherit authFile tailnet;
    enable = true;
  };

  age.secrets."preauth-${tailnet}" = {
    file = ../../secrets/tailscale/preauth-${tailnet}.age;
    mode = "0440";
    group = if config.services.headscale.enable then
      config.services.headscale.group
    else
      "0";
  };
}
