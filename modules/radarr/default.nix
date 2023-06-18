_: {
  services.radarr = {
    enable = true;
    openFirewall = true;
    # Below to be changed prior to deploy
    # group = "";
    # user = "";
    # dataDir = "/mnt/zfs/containers/radarr";
  };
}
