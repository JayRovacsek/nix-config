{
  config,
  self,
  ...
}:
{
  imports = with self.inputs.buildbot-nix.nixosModules; [
    buildbot-worker
  ];

  age = {
    identityPaths = [ "/agenix/id-ed25519-buildbot-primary" ];
    secrets = {
      workers-password = {
        file = ../../secrets/buildbot/workers-password.age;
        owner = "buildbot-worker";
      };
    };
  };

  services.buildbot-nix.worker = {
    enable = true;
    masterUrl = "${self.common.config.services.buildbot.pbProtocol}:host=${self.common.config.services.buildbot.ipv4}:port=${builtins.toString self.common.config.services.buildbot.pbPort}";
    workerPasswordFile = config.age.secrets.workers-password.path;
  };
}
