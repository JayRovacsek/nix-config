{ config, pkgs, ... }:
let
  inherit (config.flake.lib.nginx) generate-domains;

  service-name = "nextcloud";

  domains = generate-domains { inherit config service-name; };
in {
  # Extended options for nginx
  imports = [ ../../options/nginx ];

  services = {
    nextcloud = {
      enable = true;

      appstoreEnable = true;
      autoUpdateApps = {
        enable = true;
        startAt = "";
      };
      config = {
        adminpassFile = "";
        adminuser = "";
        dbhost = "";
        dbname = "";
        dbpassFile = "";
        dbport = 3306;
        dbtype = "mysql";
        dbuser = "";
        overwriteProtocol = "https";
        trustedProxies = [ "127.0.0.1" ];
      };
      configureRedis = true;

      enableImagemagick = true;
      # extraApps= {};
      # extraAppsEnable = true;
      extraOptions = { };
      globalProfiles = false;
      # Simple hack that'll be removed before deployment.
      home = if config.networking.hostName == "dragonite" then
        "/mnt/zfs/containers/nextcloud/"
      else
        "/var/lib/nextcloud";
      hostName = builtins.head domains;
      https = true;
      # logType = "systemd";
      logType = "file";
      maxUploadSize = "10G";
      package = pkgs.nextcloud27;
      # phpExtraExtensions = all: [ ];
      phpOptions = {
        "date.timezone" = config.time.timeZone;
        max_execution_time = "180";
        max_input_time = "90";
      };
      # Secret options which will be appended to Nextcloud’s config.php file
      # (written as JSON, in the same form as the services.nextcloud.
      # extraOptions option), for example {"redis":{"password":"secret"}}.
      # secretFile = {};
    };
    nginx.test = { inherit domains; };
  };
}
