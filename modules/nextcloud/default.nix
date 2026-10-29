{
  config,
  pkgs,
  lib,
  self,
  ...
}:
let
  zfsBootSupported =
    (lib.filterAttrs (n: v: n == "zfs" && v) config.boot.supportedFilesystems) != { };

  zfsServiceSupported =
    config.services.zfs.autoScrub.enable || config.services.zfs.autoSnapshot.enable;

  package = pkgs.nextcloud34;

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
    ffmpeg-full
    nodejs_24
  ];

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services = {
    mysql.settings.mysqld.innodb_buffer_pool_size = "2G";

    nextcloud = {
      home = "/var/lib/nextcloud";
      datadir = "/var/lib/nextcloud";

      configureMemories = true;

      inherit (self.common.config.services.nextcloud) hostName;

      enable = true;

      appstoreEnable = true;

      autoUpdateApps.enable = true;

      config = {
        dbtype = "mysql";
      };

      nginx.enableFastcgiRequestBuffering = true;

      extraApps = {
        inherit (package.packages.apps)
          calendar
          contacts
          files_automatedtagging
          oidc_login
          previewgenerator
          recognize
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
        enabledPreviewProviders = [
          "OC\\Preview\\BMP"
          "OC\\Preview\\GIF"
          "OC\\Preview\\JPEG"
          "OC\\Preview\\PNG"
          "OC\\Preview\\HEIC"
          "OC\\Preview\\Image"
          "OC\\Preview\\HEIC"
          "OC\\Preview\\TIFF"
          "OC\\Preview\\Movie"
        ];
        "files.chunked_upload.max_size" = 0;
        "memcache.local" = ''\OC\Memcache\Redis'';
        "memories.exiftool" = "${pkgs.exiftool}/bin/exiftool";
        "memories.vod.disable" = true;
        "memories.vod.ffmpeg" = "${pkgs.ffmpeg-full}/bin/ffmpeg";
        "memories.vod.ffprobe" = "${pkgs.ffmpeg-full}/bin/ffprobe";
        "memories.vod.nvenc" = true;
        "profile.enabled" = false;
        datadirectory = "/srv/nextcloud";
        default_locale = "en_AU";
        log_type = "file";
        loglevel = 2;
        maintenance_window_start = "12";
        overwriteprotocol = "https";
        preview_ffmpeg_path = "${pkgs.ffmpeg-full}/bin/ffmpeg";
        reduce_to_languages = [ "en" ];
        trusted_domains = [ self.common.config.services.nextcloud.ipv4 ];
        trusted_proxies = [ self.common.config.services.nginx.ipv4 ];

        # OIDC
        allow_user_to_change_display_name = false;
        lost_password_link = "disabled";

        ## URL of provider. All other URLs are auto-discovered from .well-known
        oidc_login_provider_url = "https://authelia.rovacsek.com";

        ## Client ID and secret registered with the provider
        oidc_login_client_id = "nextcloud";

        ## Automatically redirect the login page to the provider
        oidc_login_auto_redirect = false;

        ## If set to true the user will be redirected to the
        ## logout endpoint of the OIDC provider after logout
        ## in Nextcloud. After successfull logout the OIDC
        ## provider will redirect back to "oidc_login_logout_url" (MUST be set).
        oidc_login_end_session_redirect = false;

        ## Login button text
        oidc_login_button_text = "Log in with Authelia";

        ## Hide the NextCloud password change form.
        oidc_login_hide_password_form = false;

        ## Use ID Token instead of UserInfo
        oidc_login_use_id_token = false;

        oidc_login_attributes = {
          id = "preferred_username";
          name = "name";
          mail = "email";
          groups = "groups";
          is_admin = "is_nextcloud_admin";
        };

        ## Default group to add users to (optional; defaults to nothing)
        oidc_login_default_group = "oidc";

        ## Allow only users in configured value(s) to access Nextcloud. In case the user
        ## is not assigned to this value (read from oidc_login_attributes) the login
        ## will not be allowed for this user.
        ##
        ## Must be specified as an array of values (e.g. roles) that are allowed to
        ## access Nextcloud. e.g. "oidc_login_filter_allowed_values" = array("role1"; "role2")
        oidc_login_filter_allowed_values = null;

        ## Use external storage instead of a symlink to the home directory
        ## Requires the files_external app to be enabled
        oidc_login_use_external_storage = false;

        ## Set OpenID Connect scope
        oidc_login_scope = "openid profile email groups nextcloud_userinfo";

        ## Run in LDAP proxy mode
        ## In this mode; instead of creating users of its own; OIDC login
        ## will get the existing user from an LDAP database and only
        ## perform authentication with OIDC. All user data will be derived
        ## from the LDAP database instead of the OIDC user response
        ##
        ## The `id` attribute in `oidc_login_attributes` must return the
        ## "Internal Username" (see expert settings in LDAP integration)
        oidc_login_proxy_ldap = false;

        ## Disable creation of users new to Nextcloud from OIDC login.
        ## A user may be known to the IdP but not (yet) known to Nextcloud.
        ## This setting controls what to do in this case.
        ## - "true" (default): if the user authenticates to the IdP but is not known to Nextcloud;
        ##     then they will be returned to the login screen and not allowed entry;
        ## - "false": if the user authenticates but is not yet known to Nextcloud;
        ##     then the user will be automatically created; note that with this setting;
        ##     you will be allowing (or relying on) a third-party (the IdP) to create new users
        oidc_login_disable_registration = true;

        ## Fallback to direct login if login from OIDC fails
        ## Note that no error message will be displayed if enabled
        oidc_login_redir_fallback = false;

        ## Use an alternative login page
        ## This page will be php-included instead of a redirect if specified
        ## For example; setting it to `assets/login.php` will use that file
        ## in the nextcloud base directory
        ## Note: the PHP variable $OIDC_LOGIN_URL is available for redirect URI
        ## Note: you may want to try setting `oidc_login_logout_url` to your
        ## base URL if you face issues regarding re-login after logout
        oidc_login_alt_login_page = false;

        ## For development; you may disable TLS verification. Default value is `true`
        ## which should be kept in production
        oidc_login_tls_verify = true;

        ## If you get your groups from the oidc_login_attributes; you might want
        ## to create them if they are not already existing; Default is `false`.
        oidc_create_groups = true;

        ## Enable use of WebDAV via OIDC bearer token.
        oidc_login_webdav_enabled = false;

        ## Enable authentication with user/password for DAV clients that do not
        ## support token authentication (e.g. DAVx⁵)
        oidc_login_password_authentication = true;

        ## The time in seconds used to cache public keys from provider.
        ## The default value is 1 day.
        oidc_login_public_key_caching_time = 86400;

        ## The minimum time in seconds to wait between requests to the jwks_uri endpoint.
        ## Avoids that the provider will be DoSed when someone requests with unknown kids.
        ## The default is 10 seconds.
        oidc_login_min_time_between_jwks_requests = 10;

        ## The time in seconds used to cache the OIDC well-known configuration from the provider.
        ## The default value is 1 day.
        oidc_login_well_known_caching_time = 86400;

        ## If true; nextcloud will download user avatars on login.
        ## This may lead to security issues as the server does not control
        ## which URLs will be requested. Use with care.
        oidc_login_update_avatar = false;

        ## Code challenge method for PKCE flow. Recommended for enhanced security.
        ## Possible values are:
        ##	- "S256"
        ##	- "plain"
        ## The default value is empty; which won"t apply the PKCE flow.
        oidc_login_code_challenge_method = "S256";
      };
    };

    nginx = {
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
