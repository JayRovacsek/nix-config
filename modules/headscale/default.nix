{ config, pkgs, lib, ... }:
let
  unixEpoch = "'1970-01-01 00:00:00.000000000+00:00'";
  futureMeProblem = "'2050-01-01 00:00:00.000000000+00:00'";
  preauthKeys = builtins.filter (x: lib.strings.hasInfix "-preauth-key" x.name)
    (builtins.attrValues config.age.secrets);

  namespaceInsertStatements = builtins.concatStringsSep "\n" (lib.lists.imap1
    (i: v:
      "INSERT INTO namespaces ('id','created_at','updated_at','name') VALUES (${
        builtins.toString i
      }, ${unixEpoch},${unixEpoch},'${
        lib.strings.removePrefix "headscale-"
        (lib.strings.removeSuffix "-preauth-key" v.name)
      }');") preauthKeys);

  preauthInsertStatements = builtins.concatStringsSep "\n" (lib.lists.imap0
    (i: v:
      "INSERT INTO pre_auth_keys ('id','key','namespace_id','reusable','ephemeral','used','created_at','expiration') VALUES (${
        builtins.toString i
      },'`cat ${v.path}`',1,1,0,0,${unixEpoch},${futureMeProblem});")
    preauthKeys);

  sqlStatement = ''
    DELETE FROM namespaces;
    DELETE FROM pre_auth_keys;

    ${namespaceInsertStatements}

    ${preauthInsertStatements}
  '';

  script = with pkgs; ''
    bash -c "
    sqlite3 ${config.services.headscale.database.path} <<'END_SQL'

    ${sqlStatement}

    END_SQL"
  '';
in {

  imports = [ ./acl.nix ];

  age.secrets."tailscale-dns-preauth-key" = {
    file = ../../secrets/tailscale-dns-preauth-key.age;
    mode = "0400";
    owner = config.services.headscale.user;
  };

  age.secrets."headscale-db-password" = {
    file = ../../secrets/headscale-db-password.age;
    mode = "0400";
    owner = config.services.headscale.user;
  };

  age.secrets."headscale-private-key" = {
    file = ../../secrets/headscale-private-key.age;
    mode = "0400";
    owner = config.services.headscale.user;
  };

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
    # Define ACLS as json file in path - this would be far better nixified but all in time.
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
