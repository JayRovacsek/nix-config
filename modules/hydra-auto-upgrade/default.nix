_: {
  imports = [ ../../options/hydra-auto-upgrade ];

  system.hydraAutoUpgrade = {
    enable = true;
    instance = "https://hydra.rovacsek.com";
    project = "nix-config";
  };
}
