{ config, ... }:
let
  hostMap = {
    alakazam = "admin";
    dragonite = "admin";
    aipom = "download";
    cloyster = "work";
    gastly = "admin";
    igglybuff = "dns";
    jigglypuff = "dns";
    ninetales = "work";
    wigglytuff = "general";
  };
  tailnet = hostMap.${config.networking.hostName};
  authFile = config.age.secrets."tailscale-preauth-${tailnet}".path;
in {
  imports = [ ../../options/tailscale ];

  services.tailscale = {
    inherit authFile tailnet;
    enable = true;
  };

  age.secrets."tailscale-preauth-${tailnet}" = {
    file = ../../secrets/tailscale/preauth-${tailnet}.age;
    mode = "0400";
  };
}
