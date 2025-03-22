_: {
  # Extended options for jellyfin
  imports = [ ../../options/modules/jellyfin ];

  # TODO: add logic to ensure the unit loads _after_ zfs
  # mounts if they exist as they may be utilised.

  services.jellyfin = {
    enable = true;
    openFirewall = true;
    data-dir = null;
    cache-dir = null;
    metadata-dir = null;
    use-declarative-settings = true;

    user = "media";
    group = "media";
  };
}
