{ config, pkgs, lib, ... }:
let
  meta = import ./meta.nix { inherit config pkgs lib; };
  derpServerStunPort = 3478;
  metricsPort = 9090;
  grpcPort = 50443;
in {

  imports = [ ./acl.nix ../../options/headscale ../blocky ];

  age = {
    inherit (meta) secrets;
    identityPaths = [ "/agenix/id-ed25519-headscale-primary" ];
  };

  networking.firewall = {
    allowedTCPPorts = [ config.services.headscale.port grpcPort metricsPort ];
    allowedUDPPorts = [ config.services.headscale.port derpServerStunPort ];
  };

  environment.systemPackages = with pkgs; [ headscale ];

  services.headscale = {
    enable = true;
    port = 8080;
    address = "0.0.0.0";

    use-declarative-tailnets = true;

    tailnets = [
      {
        id = 1;
        name = "work";
        keys = [{
          ephemeral = false;
          inherit (config.age.secrets.preauth-work) path;
          reusable = true;
        }];
      }
      {
        id = 2;
        name = "reverse-proxy";
        keys = [{
          ephemeral = true;
          inherit (config.age.secrets.preauth-reverse-proxy) path;
          reusable = true;
        }];
      }
      {
        id = 3;
        name = "nextcloud";
        keys = [{
          ephemeral = true;
          inherit (config.age.secrets.preauth-nextcloud) path;
          reusable = true;
        }];
      }
      {
        id = 4;
        name = "log";
        keys = [{
          ephemeral = true;
          inherit (config.age.secrets.preauth-log) path;
          reusable = true;
        }];
      }
      {
        id = 5;
        name = "general";
        keys = [{
          ephemeral = false;
          inherit (config.age.secrets.preauth-general) path;
          reusable = true;
        }];
      }
      {
        id = 6;
        name = "game";
        keys = [{
          ephemeral = true;
          inherit (config.age.secrets.preauth-game) path;
          reusable = true;
        }];
      }
      {
        id = 7;
        name = "download";
        keys = [{
          ephemeral = true;
          inherit (config.age.secrets.preauth-download) path;
          reusable = true;
        }];
      }
      {
        id = 8;
        name = "dns";
        keys = [{
          ephemeral = true;
          inherit (config.age.secrets.preauth-dns) path;
          reusable = true;
        }];
      }
      {
        id = 9;
        name = "auth";
        keys = [{
          ephemeral = true;
          inherit (config.age.secrets.preauth-auth) path;
          reusable = true;
        }];
      }
      {
        id = 9;
        name = "admin";
        keys = [{
          ephemeral = false;
          inherit (config.age.secrets.preauth-admin) path;
          reusable = true;
        }];
      }
    ];

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
        magic_dns = true;
        # Replace this in time with resolved magic DNS address of my DNS resolvers.
        nameservers = [ "192.168.1.220" ];
        domains = [ "internal.rovacsek.com" ];
        base_domain = "internal.rovacsek.com";

        # Because we utilise blocky locally across all machines but 
        # Tailscale will take control of DNS once a client is connected,
        # we'll opt to inject all custom records from blocky into tailscale
        # to ensure continuity in that space.
        # Blocky only supports A and AAAA, but as we don't use ipv6 we can
        # blindly assume A records here for now.
        #
        # There's a future in which we can bootstrap tailscale suitably to 
        # simply consume DNS from a suitable node utilising blocky - but it's 
        # still a work in progress.
        extra_records = lib.mapAttrsToList (name: value: {
          inherit name value;
          type = "A";
        }) config.services.blocky.settings.customDNS.mapping;
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
