{ config, pkgs, lib, ... }: {
  networking.firewall.allowedTCPPorts = [ config.services.hydra.port ];

  # If Hydra is present, we assume a builder user is also present generally
  # to enable remote builds. However we need to force ownership of the key
  # to hydra so that it may evaluate remote builds correctly also otherwise
  # it will be refused access to the SSH key.
  # The permission sets are equivilent between hydra and builder given
  # both have access to the nix store. This doesn't really reduce security even
  # if it looks wonky - root still is assumed in the build process and therefore
  # doesn't care about the 400 permission.
  age.secrets."builder-id-ed25519" = lib.mkForce {
    file = ../../secrets/ssh/builder-id-ed25519.age;
    owner = config.users.users.hydra-queue-runner.name;
    mode = "0400";
  };

  services.hydra = {
    enable = true;
    extraConfig = ''
      evaluator_max_memory_size = 4096
      evaluator_workers = 8
      max_concurrent_evals = 2
      compress_build_logs = 1
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
}
