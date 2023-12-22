{ config, pkgs, lib, ... }:
let
  meta = import ./meta.nix { inherit config pkgs lib; };
  derpServerStunPort = 3478;
  metricsPort = 9090;
  grpcPort = 50443;
in {

  imports = [ ./acl.nix ];

  age = {
    inherit (meta) secrets;
    identityPaths = [ "/agenix/id-ed25519-headscale-primary" ];
  };

  networking.firewall = {
    allowedTCPPorts = [ config.services.headscale.port grpcPort metricsPort ];
    allowedUDPPorts = [ config.services.headscale.port derpServerStunPort ];
  };

  environment.systemPackages = with pkgs; [ sqlite-interactive headscale ];

  systemd.services."headscale-autosetup" = {
    inherit (meta) script;

    description = "Automatic configuration of Headscale";

    # make sure we perform actions prior to headscale starting
    before = [ "headscale.service" ];
    wantedBy = [ "headscale.service" ];

    # Required to use nix-shell within our script
    path = with pkgs; [ bash sqlite-interactive ];

    serviceConfig = {
      User = config.services.headscale.user;
      Group = config.services.headscale.group;
      Type = "exec";
    };
  };

  services.headscale = {
    enable = true;
    port = 8080;
    address = "0.0.0.0";

    # This will override settings that are not exposed as nix module options
    settings = {
      acl_policy_path = "/etc/headscale/acls.json";

      ## TODO: Address the below to use my own options.
      # see also: https://github.com/kradalby/dotfiles/blob/bfeb24bf2593103d8e65523863c20daf649ca656/machines/headscale.oracldn/headscale.nix#L45
      derp = {
        # TODO: Remove below once I have paths correctly configured
        # urls = [ ];
        # paths = [ "/etc/headscale/derp-server.json" ];
        update_frequency = "24h";
        auto_update_enable = true;
      };

      server_url = "https://headscale.rovacsek.com";

      ephemeral_node_inactivity_timeout = "5m";

      db_user = config.services.headscale.user;
      db_type = "sqlite3";
      db_path = "/var/lib/headscale/db.sqlite";
      db_name = "headscale";

      dns_config = {
        magicDns = true;
        # Replace this in time with resolved magic DNS address of my DNS resolvers.
        nameservers = [ "192.168.6.4" "192.168.1.220" ];
        domains = [ "rovacsek.com.internal" ];
        baseDomain = "rovacsek.com.internal";
        # More settings for this in services.headscale.settings as they currently aren't mapped in nix module
      };

      # TODO: move this to agenix
      noise.private_key_path = "/var/lib/headscale/noise_private.key";
      metrics_listen_addr = "127.0.0.1:${builtins.toString metricsPort}";
      grpc_listen_addr = "127.0.0.1:${builtins.toString grpcPort}";
      ip_prefixes = [ "100.64.0.0/10" ];

      # Enable headscale to act as DERP
      derp = {
        server = {
          enabled = true;
          region_id = 999;
          region_code = "rovacsek";
          region_name = "stun.headscale.rovacsek.com";
          stun_listen_addr = "0.0.0.0:${builtins.toString derpServerStunPort}";
        };
      };
    };
  };
}
