{
  fileSystems = let
    fsType = "zfs";
    options = [ "nofail" ];
  in {
    "/srv/storage" = {
      device = "tank/storage";
      inherit fsType options;
    };

    "/srv/containers" = {
      device = "tank/containers";
      inherit fsType options;
    };

    "/srv/isos" = {
      device = "tank/isos";
      inherit fsType options;
    };

    "/srv/tv" = {
      device = "tank/tv";
      inherit fsType options;
    };

    "/srv/backup" = {
      device = "tank/backup";
      inherit fsType options;
    };

    "/srv/personal_video" = {
      device = "tank/personal_video";
      inherit fsType options;
    };

    "/srv/work" = {
      device = "tank/work";
      inherit fsType options;
    };

    "/srv/games" = {
      device = "tank/games";
      inherit fsType options;
    };

    "/srv/movies" = {
      device = "tank/movies";
      inherit fsType options;
    };

    "/srv/nextcloud" = {
      device = "tank/nextcloud";
      inherit fsType options;
      depends = [ "/" ];
    };

    "/srv/music" = {
      device = "tank/music";
      inherit fsType options;
    };

    "/srv/downloads" = {
      device = "tank/downloads";
      inherit fsType options;
    };

    "/srv/databases" = {
      device = "tank/databases";
      inherit fsType options;
    };

    "/srv/home_assistant" = {
      device = "tank/home_assistant";
      inherit fsType options;
    };

    "/srv/logs" = {
      device = "tank/logs";
      inherit fsType options;
    };
  };
}
