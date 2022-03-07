let
  piholeUserConfig = import ../../../users/service-accounts/pihole.nix;
  stubbyUserConfig = import ../../../users/service-accounts/stubby.nix;
  piholeDockerConfig = import ../configs/pihole.nix;
  stubbyDockerConfig = import ../configs/stubby.nix;

  # Helper functions for generating correct nix configs
  userFunction = import ../../../functions/service-user.nix;
  dockerFunction = import ../../../functions/docker.nix;

  # Actual constructs used to generate useful config
  piholeUser = userFunction { userConfig = piholeUserConfig; };
  stubbyUser = userFunction { userConfig = stubbyUserConfig; };
  pihole = dockerFunction { containerConfig = piholeDockerConfig; };
  stubby = dockerFunction { containerConfig = stubbyDockerConfig; };
in {
  virtualisation.oci-containers = {
    containers = pihole // stubby;
    backend = "podman";
  };
  users.extraUsers = piholeUser.extraUsers // stubbyUser.extraUsers;
  users.extraGroups = piholeUser.extraGroups // stubbyUser.extraGroups;
}
