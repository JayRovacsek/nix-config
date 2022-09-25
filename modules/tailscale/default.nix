{ config, ... }:
let
  hasMicrovm = if builtins.hasAttr "microvm" config then true else false;

  isMicrovmGuest =
    if hasMicrovm then builtins.hasAttr "hypervisor" config.microvm else false;

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
  authFile = if isMicrovmGuest then
    "/run/agenix.d/tailscale-preauth-${tailnet}"
  else
    config.age.secrets."tailscale-preauth-${tailnet}".path;
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
