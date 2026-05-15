{
  config,
  pkgs,
  lib,
  self,
  ...
}:
let
  zfsBootSupported =
    (lib.filterAttrs (n: v: n == "zfs" && v) config.boot.supportedFilesystems)
    != { };

  zfsServiceSupported =
    config.services.zfs.autoScrub.enable || config.services.zfs.autoSnapshot.enable;

  package = pkgs.nextcloud33;
  packages = pkgs.nextcloud33Packages;

  inherit (self.lib) certificates;
  certificate-lib = certificates pkgs;
  inherit (certificate-lib) generate-self-signed;

  cert = generate-self-signed "nextcloud.rovacsek.com";

in
{
  imports = [ self.inputs.nuschtos-modules.nixosModule ];

  users = {
    groups.nextcloud.gid = 10003;
    users.nextcloud.uid = 988;
  };

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
      nextcloud-exporter-token = {
        file = ../../secrets/nextcloud/exporter-token.age;
        mode = "0400";
        owner = config.services.prometheus.exporters.nextcloud.user;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    ffmpeg-headless
    nodejs_24
  ];

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services = {
    nextcloud = {
      # TODO: Remap this to the standard /var/lib/nextcloud location
      home = "/var/lib/4ac804cde4c09910c564d43eb76cb9ca/nextcloud";
      datadir = "/var/lib/4ac804cde4c09910c564d43eb76cb9ca/nextcloud";

      configureMemories = true;
      settings = {
        datadirectory = "/srv/nextcloud";
        # Handle for version requirement of current memories install
        # See also: https://github.com/NuschtOS/nixos-modules/blob/e28ac24205fc6e0a78889b790326f99ee594b718/modules/nextcloud.nix#L103C13-L103C60
        # "memories.exiftool" = lib.mkForce (lib.getExe pkgs.exiftool-12-70);
      };

      inherit (self.common.config.services.nextcloud) hostName;

      enable = true;

      appstoreEnable = true;

      autoUpdateApps.enable = true;

      config = {
        adminpassFile = config.age.secrets.nextcloud-admin-pass-file.path;
        adminuser = "jay@rovacsek.com";
        dbtype = "mysql";
        overwriteProtocol = "https";
      };

      nginx.enableFastcgiRequestBuffering = true;

      extraApps = {
        inherit (packages.apps)
          calendar
          contacts
          files_automatedtagging
          previewgenerator
          registration
          twofactor_webauthn
          ;
      };

      configureRedis = true;
      database.createLocally = true;
      enableImagemagick = true;
      https = true;
      maxUploadSize = "20G";
      inherit package;

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
        max_execution_time = "3600";
        max_input_time = "3600";
        output_buffering = "0";
        short_open_tag = "Off";
      };

      # Secret options which will be appended to Nextcloud’s config.php file
      # (written as JSON, in the same form as the services.nextcloud.
      # extraOptions option), for example {"redis":{"password":"secret"}}.
      secretFile = config.age.secrets.nextcloud-secret-file.path;

      settings = {
        default_locale = "en_AU";
        enabledPreviewProviders = [
          "OC\\Preview\\BMP"
          "OC\\Preview\\GIF"
          "OC\\Preview\\JPEG"
          "OC\\Preview\\PNG"
          "OC\\Preview\\HEIC"
        ];
        "files.chunked_upload.max_size" = 0;
        log_type = "file";
        loglevel = 2;
        maintenance_window_start = "12";
        "memcache.local" = ''\OC\Memcache\Redis'';
        overwriteProtocol = "https";
        "profile.enabled" = false;
        preview_ffmpeg_path = "${pkgs.ffmpeg-headless}/bin/ffmpeg";
        reduce_to_languages = [ "en" ];
        trusted_proxies = [ self.common.config.services.nginx.ipv4 ];
        trusted_domains = [ self.common.config.services.nextcloud.ipv4 ];
      };
    };

    nginx = {
      statusPage = true;

      virtualHosts."nextcloud.rovacsek.com" = {
        enableAuthelia = false;
        forceSSL = true;
        # TODO: remove self signed certificate in the future.
        sslCertificate = "${cert}/share/self-signed.crt";
        sslCertificateKey = "${cert}/share/privkey.key";
      };
    };

    prometheus.exporters = {
      # TODO: implement the below
      # mysqld.enable = true;
      nextcloud = {
        enable = true;
        tokenFile = config.age.secrets.nextcloud-exporter-token.path;
        url = "https://${config.services.nextcloud.hostName}";
      };
      redis.enable = true;
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
  systemd.services =
    let
      after = lib.optionals (zfsBootSupported || zfsServiceSupported) [
        "zfs-mount.service"
      ];
    in
    {
      nextcloud-setup = {
        inherit after;
      };
      phpfpm-nextcloud = {
        inherit after;
      };
    };
}
