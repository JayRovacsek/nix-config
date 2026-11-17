{ pkgs, self, ... }:
let
  inherit (self.common.config.services) ntfy;
in
{
  # ntfy-sh has no openFirewall option; open the port directly.
  # The module defaults listen-http to [::1]:2586, so bind explicitly to the
  # configured port on all interfaces for access via the container's IP.
  networking.firewall.allowedTCPPorts = [ ntfy.port ];

  services.ntfy-sh = {
    enable = true;
    package = pkgs.ntfy-sh;

    settings = {
      listen-http = "0.0.0.0:${builtins.toString ntfy.port}";
      base-url = "${ntfy.protocol}://${ntfy.subdomain}.local";
    };
  };
}
