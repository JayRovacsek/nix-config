_: {
  androidVersion = 13;

  apps = {
    fdroid.enable = true;
    seedvault.enable = true;
    # updater.enable = true;
    updater.flavor = "grapheneos";
    vanadium.enable = false;
  };

  buildNumber = "2023100300";
  buildType = "release";
  ccache.enable = true;

  channel = "stable";
  device = "cheetah";
  deviceDisplayName = "rapidash";
  flavor = "grapheneos";
  incremental = true;
  microg.enable = true;
  # pixel.useUpstreamDriverBinaries = true;
  # signing.enable = true;
  useReproducibilityFixes = true;
  variant = "user";
}
