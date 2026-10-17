{
  config,
  lib,
  self,
  ...
}:
let
  inherit (config.services) nginx;
  inherit (self.common.config.services.authelia) address port;
  inherit (lib) recursiveUpdate;

  # TODO: move this to an authelia option.
  prod = !nginx.test.enable;

  production =
    let
      domain = "rovacsek.com";
    in
    {
      enable = prod;

      settingsFiles = [
        config.age.secrets.authelia-notifier-config.path
        config.age.secrets.authelia-secrets.path
      ];

      secrets = {
        jwtSecretFile = config.age.secrets.authelia-jwt-secret-key.path;
        sessionSecretFile = config.age.secrets.authelia-session-secret-key.path;
        storageEncryptionKeyFile = config.age.secrets.authelia-storage-encryption-key.path;
      };

      settings = {
        # https://www.authelia.com/integration/openid-connect/clients/nextcloud/#authelia
        definitions = {
          user_attributes = {
            ## Expression to evaluate admin privilege for Nextcloud.
            is_nextcloud_admin = {
              expression = ''"nextcloud-admin" in groups ? "yes" : "no"'';
            };
          };
        };

        access_control.default_policy = "deny";

        authentication_backend = {
          password_reset.disable = false;
          refresh_interval = "5m";
          file = {
            inherit (config.age.secrets.authelia-users) path;
            # As per: https://www.authelia.com/reference/cli/authelia/authelia_crypto_hash_generate_argon2/
            password = {
              algorithm = "argon2id";
              iterations = 3;
              key_length = 32;
              salt_length = 16;
              memory = 65536;
              parallelism = 4;
            };
          };
        };

        default_2fa_method = "totp";
        default_redirection_url = "https://authelia.${domain}";

        log = {
          format = "json";
          keep_stdout = false;
          level = "debug";
        };

        session = {
          inherit domain;
          expiration = "1h";
          inactivity = "5m";
        };

        server = {
          buffers = {
            read = 8196;
            write = 8196;
          };
          inherit address;
        };

        storage.local.path = "/var/lib/authelia-production/authelia.sqlite";

        telemetry = {
          metrics = {
            address = "tcp://127.0.0.1:9959";
            enabled = false;
          };
        };

        theme = "dark";

        totp = {
          issuer = domain;
          period = 30;
          skew = 1;
        };
      };
    };

  test =
    let
      domain = "test.rovacsek.com";
    in
    recursiveUpdate production {
      inherit (nginx.test) enable;
      settings = {
        log.level = "debug";
        default_redirection_url = "https://authelia.${domain}";
        notifier.disable_startup_check = false;
        storage.local.path = "/var/lib/authelia-test/authelia.sqlite";
        totp.issuer = domain;
      };
    };
in
{
  age = {
    identityPaths = [ "/agenix/id-ed25519-authelia-primary" ];
    secrets =
      let
        owner = config.services.authelia.instances."${if prod then "production" else "test"}".user;
      in
      {
        authelia-secrets = {
          file = ../../secrets/authelia/secrets.age;
          inherit owner;
        };

        authelia-jwt-secret-key = {
          file = ../../secrets/authelia/jwt-secret-key.age;
          inherit owner;
        };
        authelia-session-secret-key = {
          file = ../../secrets/authelia/session-secret-key.age;
          inherit owner;
        };
        authelia-storage-encryption-key = {
          file = ../../secrets/authelia/storage-encryption-key.age;
          inherit owner;
        };
        authelia-notifier-config = {
          file = ../../secrets/authelia/notifier-config.age;
          inherit owner;
        };
        authelia-users = {
          file = ../../secrets/authelia/users.age;
          inherit owner;
        };
      };
  };

  networking.firewall.allowedTCPPorts = [ port ];

  services.authelia.instances = {
    inherit production test;
  };
}
