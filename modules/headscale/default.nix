{
  config,
  lib,
  self,
  ...
}:
let
  inherit (self.common.config.services.headscale)
    derpServerStunPort
    grpcPort
    metricsPort
    port
    ;

  # Use the configured value for ACL generation
  inherit (config.services.headscale.settings.dns) base_domain;
  # Default value from flake common config
  defaultBaseDomain = self.common.config.services.headscale.base_domain;

  # Each entry maps to a preauth-<name>.age secret. Keys are tagged so
  # their nodes register as tagged devices (headscale 0.28+ requires a key
  # to be user-owned or tagged, never neither).
  preauthKeys = [
    {
      name = "work";
      ephemeral = false;
      inherit (config.age.secrets.preauth-work) path;
    }
    {
      name = "reverse-proxy";
      inherit (config.age.secrets.preauth-reverse-proxy) path;
    }
    {
      name = "nextcloud";
      inherit (config.age.secrets.preauth-nextcloud) path;
    }
    {
      name = "log";
      inherit (config.age.secrets.preauth-log) path;
    }
    {
      name = "general";
      ephemeral = false;
      inherit (config.age.secrets.preauth-general) path;
    }
    {
      name = "game";
      inherit (config.age.secrets.preauth-game) path;
    }
    {
      name = "download";
      inherit (config.age.secrets.preauth-download) path;
    }
    {
      name = "dns";
      inherit (config.age.secrets.preauth-dns) path;
    }
    {
      name = "auth";
      inherit (config.age.secrets.preauth-auth) path;
    }
    {
      name = "admin";
      ephemeral = false;
      inherit (config.age.secrets.preauth-admin) path;
    }
  ];

  # Admin devices can reach everything on the tailnet. Since 0.29, "*" as a
  # destination resolves to the Tailscale CGNAT/ULA ranges rather than all
  # IPs, which is exactly the intent here.
  allow-admin-to-all = [
    {
      action = "accept";
      src = [ "tag:admin" ];
      dst = [ "*:*" ];
    }
  ];

  allow-all-to-dns = [
    {
      action = "accept";
      src = [ "*" ];
      dst = [ "tag:dns:53,8053" ];
    }
  ];

  # Devices sharing a key (same namespace) can talk to each other.
  allow-to-self = builtins.map (x: {
    action = "accept";
    src = [ "tag:${x.name}" ];
    dst = [ "tag:${x.name}:*" ];
  }) preauthKeys;

  # Ref: https://tailscale.com/kb/1103/exit-nodes#prerequisites
  allow-all-to-internet-via-exit-node = [
    {
      action = "accept";
      src = [ "*" ];
      dst = [
        "0.0.0.0/0:*"
        "::/0:*"
      ];
    }
  ];

in
{
  imports = [
    ../../options/modules/headscale
  ];

  age.secrets = builtins.foldl' (a: b: a // b) { } (
    builtins.map
      (x: {
        "${lib.strings.removeSuffix ".age" x}" = {
          file = ../../secrets/tailscale/${x};
          mode = "0400";
          owner = config.services.headscale.user;
        };
      })
      (
        builtins.filter (z: (lib.strings.hasSuffix ".age" z)) (
          builtins.attrNames (builtins.readDir ../../secrets/tailscale)
        )
      )
  );

  networking.firewall = {
    allowedTCPPorts = [
      port
      grpcPort
      metricsPort
    ];
    allowedUDPPorts = [
      port
      derpServerStunPort
    ];
  };

  services.headscale = {
    enable = true;
    inherit port;
    address = "0.0.0.0";

    inherit preauthKeys;

    acl.acls =
      allow-admin-to-all ++ allow-all-to-dns ++ allow-to-self ++ allow-all-to-internet-via-exit-node;

    # This will override settings that are not exposed as nix module options
    settings = {
      derp = {
        server = {
          enabled = true;
          region_id = 999;
          region_code = "rovacsek";
          region_name = "stun.headscale.rovacsek.com";
          stun_listen_addr = "0.0.0.0:${builtins.toString derpServerStunPort}";
        };
        auto_update_enabled = true;
        update_frequency = "24h";
      };

      server_url = "https://headscale.rovacsek.com";

      node.ephemeral.inactivity_timeout = "5m";

      dns = {
        base_domain = lib.mkDefault defaultBaseDomain;
        override_local_dns = false;
        magic_dns = true;
        # Replace this in time with resolved magic DNS address of my DNS resolvers.
        nameservers.global = [ "192.168.1.220" ];
        search_domains = [ base_domain ];

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
        extra_records = lib.mkIf config.services.blocky.enable (
          lib.mapAttrsToList (name: value: {
            inherit name value;
            type = "A";
          }) config.services.blocky.settings.customDNS.mapping
        );
      };

      metrics_listen_addr = "0.0.0.0:${builtins.toString metricsPort}";
      grpc_listen_addr = "127.0.0.1:${builtins.toString grpcPort}";
    };
  };
}
