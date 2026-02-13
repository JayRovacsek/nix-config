{
  self,
  ...
}:
let
  inherit (self.common.config.services) anubis hydra;
in
{
  networking.firewall.allowedTCPPorts = [ anubis.port ];

  services.anubis = {
    instances.default = {
      enable = true;

      settings = {
        BIND_NETWORK = anubis.bind-network;
        BIND = "${anubis.ipv4}:${builtins.toString anubis.port}";
        METRICS_BIND_NETWORK = anubis.metrics-bind-network;
        METRICS_BIND = "${anubis.ipv4}:${builtins.toString anubis.metrics-port}";
        TARGET = "${hydra.protocol}://${hydra.ipv4}:${builtins.toString hydra.port}";
      };

      policy = {
        useDefaultBotRules = true;

        settings = {
          logging = {
            format = "text";
            level = "info";
          };
        };
      };
    };
  };
}
