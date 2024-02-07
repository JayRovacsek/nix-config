_: {
  # Extended options for jellyfin
  imports = [ ../../options/jellyfin ];

  # TODO: add logic to ensure the unit loads _after_ zfs
  # mounts if they exist as they may be utilised.

  services.jellyfin = {
    enable = true;
    openFirewall = true;
    data-dir = null;
    cache-dir = null;
    metadata-dir = null;
    # Available, but useless to us as our settings already exist as default
    # dlna-settings = { };
    # encoding-settings = { };
    # logging-settings = { };
    # network-settings = { };
    # notification-settings = { };
    # system-settings = { };
    use-declarative-settings = true;

    user = "media";
    group = "media";
  };
}
