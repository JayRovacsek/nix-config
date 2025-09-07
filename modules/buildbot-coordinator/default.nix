{
  config,
  self,
  ...
}:
{
  imports = with self.inputs.buildbot-nix.nixosModules; [
    buildbot-master
  ];

  age = {
    identityPaths = [ "/agenix/id-ed25519-buildbot-primary" ];
    secrets = {
      cookie-secret = {
        file = ../../secrets/buildbot/cookie-secret.age;
        owner = "buildbot";
      };

      github-app-secret = {
        file = ../../secrets/buildbot/github-app-secret.age;
        owner = "buildbot";
      };

      oauth-secret = {
        file = ../../secrets/buildbot/oauth-secret.age;
        owner = "buildbot";
      };

      webhook-secret = {
        file = ../../secrets/buildbot/webhook-secret.age;
        owner = "buildbot";
      };

      workers-file = {
        file = ../../secrets/buildbot/workers-file.age;
        owner = "buildbot";
      };
    };
  };

  networking.firewall.allowedTCPPorts = with config.services.buildbot-master; [
    pbPort
    port
  ];

  services.buildbot-nix.master = {
    admins = [
      "JayRovacsek"
    ];

    branches = {
      staging.matchGlob = "staging";
      testing.matchGlob = "testing";
    };

    enable = true;

    evalWorkerCount = 1;

    domain = "buildbot.rovacsek.com";

    github = {
      authType.app.id = 1911209;
      authType.app.secretKeyFile = config.age.secrets.github-app-secret.path;
      oauthSecretFile = config.age.secrets.oauth-secret.path;
      oauthId = "Iv23liBwfcmM679PFgrn";
      webhookSecretFile = config.age.secrets.webhook-secret.path;
    };

    useHTTPS = true;

    pullBased.repositories = {
      nix-config = {
        url = "https://github.com/JayRovacsek/nix-config.git";
        defaultBranch = "main";
      };
    };

    workersFile = config.age.secrets.workers-file.path;
  };
}
