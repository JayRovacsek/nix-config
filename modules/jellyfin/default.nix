{ ... }: {
  # Extended options for jellyfin
  imports = [ ../../options/jellyfin ];

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
  };
}
