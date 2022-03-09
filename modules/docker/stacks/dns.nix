let
  piholeUserConfig = import ../../../users/service-accounts/pihole.nix;
  piholeDockerConfig = import ../configs/pihole.nix;

  # Helper functions for generating correct nix configs
  userFunction = import ../../../functions/service-user.nix;
  dockerFunction = import ../../../functions/docker.nix;

  # Actual constructs used to generate useful config
  piholeUser = userFunction { userConfig = piholeUserConfig; };
  pihole = dockerFunction { containerConfig = piholeDockerConfig; };
in {
  virtualisation.oci-containers = {
    containers = pihole;
    backend = "podman";
  };
  users.extraUsers = piholeUser.extraUsers;
  users.extraGroups = piholeUser.extraGroups;
}
