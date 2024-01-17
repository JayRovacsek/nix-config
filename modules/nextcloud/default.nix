{ config, pkgs, lib, ... }:
let
  inherit (config.flake.lib.nginx) generate-domains generate-vhosts;

  service-name = "nextcloud";

  domains = generate-domains { inherit config service-name; };

  # The below is pretty differt to other use-cases of generate-vhosts
  # as nextcloud somewhat enforces use of nginx in the nixos module 
  # leaving us in a position where we want to merge our position on 
  # TLS & other settings.
  # Effectively the below is a hack doing so - port here is not important as 
  # it's not used in this context
  virtualHosts = lib.foldlAttrs (acc: name: value:
    acc // {
      ${name} = { inherit (value) forceSSL sslCertificate sslCertificateKey; };
    }) { } (generate-vhosts { inherit config service-name; });

  zfsBootSupported =
    builtins.any (x: x == "zfs") config.boot.supportedFilesystems;

  zfsServiceSupported = config.services.zfs.autoScrub.enable
    || config.services.zfs.autoSnapshot.enable;

in {
  # Extended options for nginx
  imports = [ ../../options/nginx ];

  age = {
    identityPaths = [ "/agenix/id-ed25519-nextcloud-primary" ];

    secrets = {
      nextcloud-admin-pass-file = {
        file = ../../secrets/nextcloud/admin-pass.age;
        mode = "0400";
        # Magic value as per: https://github.com/NixOS/nixpkgs/blob/54aac082a4d9bb5bbc5c4e899603abfb76a3f6d6/nixos/modules/services/web-apps/nextcloud.nix#L975C33-L975C42
        owner = "nextcloud";
      };
      nextcloud-secret-file = {
        file = ../../secrets/nextcloud/secret-file.age;
        mode = "0400";
        owner = "nextcloud";
      };
    };
  };

  services = {
    nextcloud = {
      enable = true;

      appstoreEnable = true;

      autoUpdateApps = {
        enable = true;
        startAt = "";
      };

      config = {
        adminpassFile = config.age.secrets.nextcloud-admin-pass-file.path;
        adminuser = "jay@rovacsek.com";
        dbtype = "mysql";
        overwriteProtocol = "https";
        trustedProxies = [ "127.0.0.1" ];
      };

      configureRedis = true;

      # The below is only useful if we're starting fresh - 
      # however we're migrating so the use of this setting is 
      # */freedom* no bueno */s*
      # Here if we're testing we'll create locally, otherwise 
      # required configuration settings are kept in the secretFile
      database.createLocally = config.services.nginx.test.enable;

      enableImagemagick = true;
      # extraApps= {};
      # extraAppsEnable = true;
      hostName = builtins.head domains;
      https = true;
      logType = "file";
      maxUploadSize = "10G";
      package = pkgs.nextcloud27;
      phpOptions = {
        "date.timezone" = config.time.timeZone;
        max_execution_time = "180";
        max_input_time = "90";
      };
      # Secret options which will be appended to Nextcloud’s config.php file
      # (written as JSON, in the same form as the services.nextcloud.
      # extraOptions option), for example {"redis":{"password":"secret"}}.
      secretFile = config.age.secrets.nextcloud-secret-file.path;
    };
    nginx = {
      test = { inherit domains; };
      inherit virtualHosts;
    };
  };

  # If boot or zfs services are utilised, ensure zfs mounts are completed
  # prior to starting nextcloud related services. 
  # Note that both nextcloud-cron and nextcloud-update-plugins 
  # as well as other services such as nginx exist also as part of 
  # nextcloud, however they are either dependent on nextcloud-setup
  # or phpfpm-nextcloud so we do not need to add the after here as it's
  # implied.
  systemd.services = let
    after = lib.optionals (zfsBootSupported || zfsServiceSupported)
      [ "zfs-mount.service" ];
  in {
    nextcloud-setup = { inherit after; };
    phpfpm-nextcloud = { inherit after; };
  };
}
