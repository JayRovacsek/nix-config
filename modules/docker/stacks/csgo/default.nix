let
  csgoUserConfig = import ../../../../users/service-accounts/csgo.nix;
  csgoDockerConfig = import ../../configs/csgo.nix;

  # Helper functions for generating correct nix configs
  userFunction = import ../../../../functions/service-user.nix;
  dockerFunction = import ../../../../functions/docker.nix;

  # Actual constructs used to generate useful config
  csgoUser = userFunction { userConfig = csgoUserConfig; };
  csgo = dockerFunction { containerConfig = csgoDockerConfig; };
in {
  virtualisation.oci-containers = { containers = csgo; };
  users.extraUsers = csgoUser.extraUsers;
  users.extraGroups = csgoUser.extraGroups;
}
