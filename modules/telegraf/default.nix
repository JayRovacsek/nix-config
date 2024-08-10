{ pkgs, self, ... }:
let
  inherit (self.common.networking.services.telegraf.output.prometheus) port;
in
{
  networking.firewall.allowedTCPPorts = [ port ];
  services = {
    telegraf = {
      enable = true;
      extraConfig = {
        inputs = {
          execd = {
            command = [
              "${pkgs.zfs}/libexec/zfs/zpool_influxdb"
              "--execd"
            ];
            data_format = "influx";
            restart_delay = "10s";
            signal = "STDIN";
          };
          zfs = { };
        };
        outputs.prometheus_client.listen = ":${builtins.toString port}";
      };
    };
  };
}
