_: {
  system.autoUpgrade = {
    enable = true;
    # Poll the `main` branch for changes once a minute
    dates = "minutely";
    # You need this if you poll more than once an hour
    flags = [ "--option" "tarball-ttl" "0" ];
    flake = "github:JayRovacsek/nix-config";
  };
}
