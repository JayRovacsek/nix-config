{ config, pkgs, lib, ... }:
let
  unixEpoch = "'1970-01-01 00:00:00.000000000+00:00'";
  futureMeProblem = "'2050-01-01 00:00:00.000000000+00:00'";

  # Okay, so the below is straigh pain to decipher, this is likely due to my nix 
  # capabilities but translates as follows:
  # * read the contents of our secrets directory, grabbing all file names
  # * where the filename includes "tailscale" or "headscale"
  # * map keys to a structure of ("name" minus ".age") = set representing agenix config
  #
  # So yeah, not pretty but scales to pull in all secrets that include the 
  # "-preauth-key" value so we can generate entries into sqlite on every rebuild
  secrets = builtins.foldl' (a: b: a // b) { } (builtins.map (x: {
    "${lib.strings.removeSuffix ".age" x}" = {
      file = ../../secrets/${x};
      mode = "0400";
      owner = config.services.headscale.user;
    };
  }) (builtins.filter (z:
    (lib.strings.hasInfix "tailscale" z || lib.strings.hasInfix "headscale" z))
    (builtins.attrNames (builtins.readDir ../../secrets))));

  preauthKeys = builtins.filter (x: lib.strings.hasInfix "-preauth-key" x.name)
    (builtins.attrValues config.age.secrets);

  # CREATE TABLE `namespaces` (`id` integer,`created_at` datetime,`updated_at` datetime,`deleted_at` datetime,`name` text UNIQUE,PRIMARY KEY (`id`));
  namespaceInsertStatements = builtins.concatStringsSep "\n" (lib.lists.imap0
    (i: v:
      "INSERT INTO namespaces ('id','created_at','updated_at','name') VALUES (${
        builtins.toString i
      }, ${unixEpoch},${unixEpoch},'${
        lib.strings.removePrefix "tailscale-"
        (lib.strings.removeSuffix "-preauth-key" v.name)
      }');") preauthKeys);

  # CREATE TABLE `pre_auth_keys` (`id` integer,`key` text,`namespace_id` integer,`reusable` numeric,`ephemeral` numeric DEFAULT false,`used` numeric DEFAULT false,`created_at` datetime,`expiration` datetime,PRIMARY KEY (`id`));
  preauthInsertStatements = builtins.concatStringsSep "\n" (lib.lists.imap0
    (i: v:
      "INSERT INTO pre_auth_keys ('id','key','namespace_id','reusable','ephemeral','used','created_at','expiration') VALUES (${
        builtins.toString i
      },'`cat ${v.path}`',${
        builtins.toString i
      },1,0,0,${unixEpoch},${futureMeProblem});") preauthKeys);

  # The delete from all tables below could probably be done better but I can't DB :)
  # It's required to ensure we have a blank slate moving in and no residual state can be 
  # left behind causing issues later
  sqlStatement = ''
    delete from namespaces;
    delete from pre_auth_keys;
    delete from machines;
    delete from kvs;
    delete from api_keys;

    ${namespaceInsertStatements}

    ${preauthInsertStatements}
  '';

  script = with pkgs; ''
    bash -c "
    sqlite3 ${config.services.headscale.database.path} <<'END_SQL'

    ${sqlStatement}

    END_SQL"
  '';

  imports = map (n: "${./pkgConfigs}/${n}")
    (builtins.attrNames (builtins.readDir ./pkgConfigs));
in {

  imports = [ ./acl.nix ];

  age.secrets = secrets;

  networking.firewall = {
    allowedTCPPorts = [ config.services.headscale.port ];
    allowedUDPPorts = [ config.services.headscale.port ];
  };

  environment.systemPackages = with pkgs; [ headscale sqlite-interactive ];

  systemd.services."headscale-autosetup" = {
    inherit script;

    description = "Automatic configuration of Headscale";

    # make sure we perform actions prior to headscale starting
    before = [ "headscale.service" ];
    wantedBy = [ "multi-user.target" "headscale.service" ];

    # Required to use nix-shell within our script
    path = with pkgs; [ bash sqlite-interactive ];

    serviceConfig = {
      User = config.services.headscale.user;
      Group = config.services.headscale.group;
      Type = "exec";
    };
  };

  services.headscale = {
    settings = {
      metrics_listen_addr = "127.0.0.1:9090";
      grpc_listen_addr = "0.0.0.0:50443";
      grpc_allow_insecure = false;
      private_key_path = "/var/lib/headscale/private.key";
      ip_prefixes = [ "100.64.0.0/10" ];
      disable_check_updates = true;
      randomize_client_port = false;
    };
    enable = true;
    address = "0.0.0.0";
    serverUrl = "https://headscale.rovacsek.com";
    dns = {
      magicDns = true;
      # Replace this in time with resolved magic DNS address of my DNS resolvers.
      nameservers = [ "1.1.1.1" ];
      domains = [ "rovacsek.com.internal" ];
      baseDomain = "rovacsek.com.internal";
    };
    logLevel = "info";
    ## TODO: Address the below to use my own options.
    # see also: https://github.com/kradalby/dotfiles/blob/bfeb24bf2593103d8e65523863c20daf649ca656/machines/headscale.oracldn/headscale.nix#L45
    # derp = {
    #   urls = [];
    #   paths = [];
    # updateFrequency
    # autoUpdate
    # };
    # TODO: make this dynamic depending on a search through /etc configs for this system
    aclPolicyFile = "/etc/headscale/acls.json";
    # I can see the below being problematic while still using SWAG.
    # Will need to dig into changing this once I can extract SWAG into nixified modules.
    # tls.letsencrypt = {
    #   certFile = "";
    #   keyFile = ""; # Both require a path on host to existing valid certs
    # };
    # Looks like the below will require uplift to authelia 
    # see: https://www.authelia.com/docs/configuration/identity-providers/oidc.html#openid-connect
    # openIdConnect = {
    #   issuer = "";
    #   domainMap = { };
    #   clientId = "headscale";
    #   clientSecretFile = config.age.secrets.headscale-oidc-secret.path;
    # };
    # I don't think the below is really required just yet, a default of 
    # 30 mins seems just fine
    # ephemeralNodeInactivityTimeout = "5m";

    database = {
      user = "headscale";
      type = "sqlite3";
      path = "/var/lib/headscale/db.sqlite";
      name = "headscale";
      passwordFile = config.age.secrets.headscale-db-password.path;
    };
  };
}
