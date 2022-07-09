{
  proto = "virtiofs";
  tag = "tailscale-dns-preauth-key";
  source = "/run/agenix.d/static/tailscale-dns-preauth-key.age";
  mountPoint = "/run/agenix.d/static/tailscale-dns-preauth-key.age";
  socket = "tailscale-dns-preauth-key.socket";
}
