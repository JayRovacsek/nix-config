{ config, lib, pkgs, ... }:

## https://github.com/ethnt/orchard/tree/8a3ba1010932f884e45676a0aa2c01bfc211ccc7/modules/services

with lib;

let
  cfg = services.headscale;
  settingsFormat = pkgs.formats.yaml { };
in {
  options.orchard.services.headscale = {
    enable = mkEnableOption "Enable Headscale server";
    package = mkOption {
      type = types.package;
      default = pkgs.headscale;
    };
    externalServerUrl = mkOption { type = types.str; };
    namespaces = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
    extraSettings = mkOption {
      type = settingsFormat.type;
      default = { };
    };
  };

  config = mkIf cfg.enable {
    services.headscale = {
      inherit (cfg) enable;
      serverUrl = cfg.externalServerUrl;
      dns = {
        baseDomain = "";
        magicDns = true;
      };
      settings =
        mkMerge [ { grpc_listen_addr = "127.0.0.1:50443"; } cfg.extraSettings ];
    };

    systemd.services."headscale-provisioning" = {
      serviceConfig.Type = "oneshot";

      after = [ "headscale.service" ];
      wantedBy = [ "headscale.service" ];

      script = ''
        # Wait for headscale to be ready
        sleep 2

        ${concatStringsSep "\n" (map (namespace:
          "${cfg.package}/bin/headscale namespaces create ${namespace}")
          cfg.namespaces)}
      '';
    };
  };
}
