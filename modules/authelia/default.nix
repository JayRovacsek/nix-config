{ config, ... }: {
  age = {
    identityPaths = [ "/agenix/id-ed25519-authelia-primary" ];
    secrets = {
      authelia-jwt-secret-key = {
        file = ../../secrets/authelia/jwt-secret-key.age;
        owner = config.services.authelia.instances.production.user;
      };
      authelia-session-secret-key = {
        file = ../../secrets/authelia/session-secret-key.age;
        owner = config.services.authelia.instances.production.user;
      };
      authelia-storage-encryption-key = {
        file = ../../secrets/authelia/storage-encryption-key.age;
        owner = config.services.authelia.instances.production.user;
      };
    };
  };

  networking.firewall.allowedTCPPorts =
    [ config.services.authelia.instances.production.settings.server.port ];

  services.authelia.instances.production = {
    enable = true;
    secrets = {
      jwtSecretFile = config.age.secrets.authelia-jwt-secret-key.path;
      sessionSecretFile = config.age.authelia-session-secret-key.path;
      storageEncryptionKeyFile =
        config.age.secrets.authelia-storage-encryption-key.path;
    };
    settings = {
      access_control = {
        default_policy = "deny";
        rules = [
          {
            domain = "duplicati.rovacsek.com";
            policy = "two_factor";
            subject = "group:duplicati";
          }
          {
            domain = "homeassistant.rovacsek.com";
            policy = "two_factor";
            subject = "group:homeassistant";
          }
          {
            domain = "lidarr.rovacsek.com";
            policy = "two_factor";
            subject = "group:lidarr";
          }
          {
            domain = "ombi.rovacsek.com";
            policy = "two_factor";
            subject = "group:ombi";
          }
          {
            domain = "pfsense.rovacsek.com";
            policy = "two_factor";
            subject = "group:pfsense";
          }
          {
            domain = "portainer.rovacsek.com";
            policy = "two_factor";
            subject = "group:portainer";
          }
          {
            domain = "prowlarr.rovacsek.com";
            policy = "two_factor";
            subject = "group:prowlarr";
          }
          {
            domain = "radarr.rovacsek.com";
            policy = "two_factor";
            subject = "group:radarr";
          }
          {
            domain = "sonarr.rovacsek.com";
            policy = "two_factor";
            subject = "group:sonarr";
          }
          {
            domain = "tdarr.rovacsek.com";
            policy = "two_factor";
            subject = "group:tdarr";
          }
          {
            domain = "tdarr.rovacsek.com";
            policy = "two_factor";
            subject = "group:tdarr";
          }
        ];
      };

      authentication_backend = {
        password_reset.disable = false;
        refresh_interval = "5m";
        file = {
          # TODO: create declarative option for this
          path = "/config/users_database.yml";
          password = {
            algorithm = "argon2id";
            iterations = 1;
            key_length = 32;
            salt_length = 16;
            memory = 1024;
            parallelism = 8;
          };
        };
      };

      default_2fa_method = "totp";
      default_redirection_url = "https://authelia.rovacsek.com";

      log = {
        file_path = "/var/log/authelia/authelia.log";
        format = "json";
        keep_stdout = false;
        level = "debug";
      };

      session = {
        domain = "rovacsek.com";
        expiration = "1h";
        inactivity = "5m";
        remember_me_duration = "1M";
      };

      server = {
        buffers = {
          read = 4096;
          write = 4096;
        };
        path = "authelia";
        host = "localhost";
        port = 9091;
      };

      telemetry = {
        metrics = {
          address = "tcp://127.0.0.1:9959";
          enabled = false;
        };
      };

      theme = "dark";

      totp = {
        issuer = "rovacsek.com";
        period = 30;
        skew = 1;
      };
    };
  };
}
