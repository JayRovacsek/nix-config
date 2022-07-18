{
  proto = "virtiofs";
  tag = "tailscale-preauth-keys";
  source = "/run/agenix.d/tailscale";
  mountPoint = "/run/agenix.d/tailscale";
  socket = "tailscale-preauth-keys.socket";
}
