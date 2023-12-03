{ config, pkgs, lib, ... }:
let
  inherit (config.flake.lib.nginx) generate-domains generate-vhosts;

  service-name = "hydra";

  domains = generate-domains { inherit config service-name; };

  overrides = {
    locations."/".extraConfig = ''
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    '';
  };

  virtualHosts = generate-vhosts {
    inherit config service-name overrides;
    inherit (config.services.hydra) port;
  };
in {
  # Extended options for nginx
  imports = [ ../../options/nginx ];

  networking.firewall.allowedTCPPorts = [ config.services.hydra.port ];

  # If Hydra is present, we assume a builder user is also present generally
  # to enable remote builds. However we need to force ownership of the key
  # to hydra so that it may evaluate remote builds correctly also otherwise
  # it will be refused access to the SSH key.
  # The permission sets are equivalent between hydra and builder given
  # both have access to the nix store. This doesn't really reduce security even
  # if it looks wonky - root still is assumed in the build process and therefore
  # doesn't care about the 400 permission.
  age = {
    identityPaths = [ "/agenix/id-ed25519-hydra-primary" ];
    secrets = {
      "builder-id-ed25519" = lib.mkForce {
        file = ../../secrets/ssh/builder-id-ed25519.age;
        owner = config.users.users.hydra-queue-runner.name;
        mode = "0400";
      };

      "hydra-github-token" = {
        file = ../../secrets/hydra/hydra-github-token.age;
        owner = config.users.users.hydra.name;
        inherit (config.users.users.hydra) group;
        mode = "0400";
      };
    };
  };

  environment.etc."hydra/github_token".source =
    config.age.secrets.hydra-github-token.path;

  nix.extraOptions = ''
    extra-allowed-uris = https://gitlab.com/api/v4/projects/rycee%2Fnmd https://git.sr.ht/~rycee/nmd
  '';

  services = {
    hydra = {
      enable = true;
      # READ INTO: https://hydra.nixos.org/build/196107287/download/1/hydra/plugins/index.html?highlight=github#github-status
      extraConfig = ''
        evaluator_max_memory_size = 4096
        evaluator_workers = 8
        max_concurrent_evals = 2
        compress_build_logs = 1
        <githubstatus>
          jobs = .*
          inputs = src
          context = hydra
        </githubstatus>
      '';
      hydraURL = "https://hydra.rovacsek.com";
      listenHost = "*";
      minimumDiskFree = 25;
      minimumDiskFreeEvaluator = 50;
      notificationSender = "";
      package = pkgs.hydra_unstable;
      port = 3000;
      smtpHost = null;
      tracker = "";
      useSubstitutes = true;
    };

    nginx = {
      test = { inherit domains; };
      inherit virtualHosts;
    };
  };
}
