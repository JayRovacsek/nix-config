{ config, pkgs, lib, self, ... }:
let
  zfsBootSupported =
    builtins.any (x: x == "zfs") config.boot.supportedFilesystems;

  zfsServiceSupported = config.services.zfs.autoScrub.enable
    || config.services.zfs.autoSnapshot.enable;
in {
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

  networking.firewall.allowedTCPPorts = [ 80 443 ];

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
      };

      configureRedis = true;

      database.createLocally = true;

      enableImagemagick = true;

      extraOptions = {
        enabledPreviewProviders = [
          "OC\\Preview\\BMP"
          "OC\\Preview\\GIF"
          "OC\\Preview\\JPEG"
          "OC\\Preview\\PNG"
          "OC\\Preview\\HEIC"
        ];
        log_type = "file";
        loglevel = 2;
        "profile.enabled" = false;
        trusted_proxies = [ self.common.networking.services.nginx.ipv4 ];
        trusted_domains = [ "192.168.10.3" ];
      };

      # It sucks, but we're already behind a proxy with this instance - let it handle TLS
      https = false;
      maxUploadSize = "10G";
      package = pkgs.nextcloud28;
      phpOptions = {
        "date.timezone" = config.time.timeZone;
        "opcache.enable_cli" = "1";
        "opcache.fast_shutdown" = "1";
        "opcache.interned_strings_buffer" = "64";
        "opcache.jit_buffer_size" = "256M";
        "opcache.jit" = "1255";
        "opcache.max_accelerated_files" = "150000";
        "opcache.memory_consumption" = "256";
        "opcache.revalidate_freq" = "60";
        "opcache.save_comments" = "1";
        "openssl.cafile" = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
        catch_workers_output = "yes";
        display_errors = "stderr";
        error_reporting = "E_ALL & ~E_DEPRECATED & ~E_STRICT";
        expose_php = "Off";
        max_execution_time = "30";
        max_input_time = "90";
        output_buffering = "0";
        short_open_tag = "Off";
      };
      # Secret options which will be appended to Nextcloud’s config.php file
      # (written as JSON, in the same form as the services.nextcloud.
      # extraOptions option), for example {"redis":{"password":"secret"}}.
      secretFile = config.age.secrets.nextcloud-secret-file.path;
    };

    redis.servers.nextcloud.settings = {
      maxmemory = "512m";
      maxmemory-policy = "volatile-lfu";
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
