_: {
  users.groups = {
    users = { gid = 100; };

    jellyfin = {
      gid = 10001;
      members = [ "jellyfin" ];
    };

    media = {
      gid = 10002;
      members = [ "jellyfin" "tdarr" ];
    };

    nextcloud = {
      gid = 10003;
      members = [ "nextcloud" ];
    };

    minecraft = {
      gid = 10004;
      members = [ "minecraft" ];
    };

    download = {
      gid = 10005;
      members = [ "download" ];
    };

    authelia = {
      gid = 10006;
      members = [ "authelia" ];
    };

    home_assistant = {
      gid = 10008;
      members = [ "home_assistant" ];
    };

    unify = {
      gid = 10010;
      members = [ "unify" ];
    };

    redis = {
      gid = 10011;
      members = [ "redis" ];
    };

    db = {
      gid = 10012;
      members = [ "db" ];
    };

    backup = {
      gid = 10014;
      members = [ "backup" ];
    };

    swag = {
      gid = 10015;
      members = [ "swag" "jay" ];
    };

    games = {
      gid = 10017;
      members = [ "minecraft" "valheim" ];
    };

    duin = {
      gid = 10018;
      members = [ "duin" ];
    };
  };

  users.extraUsers = let
    isSystemUser = true;
    createHome = false;
    description = "User account generated for running a specific service";
  in {
    jellyfin = {
      inherit isSystemUser createHome description;
      uid = 998;
      group = "jellyfin";
    };

    minecraft = {
      inherit isSystemUser createHome description;
      uid = 989;
      group = "games";
    };

    download = {
      inherit isSystemUser createHome description;
      uid = 984;
      group = "download";
    };

    backup = {
      inherit isSystemUser createHome description;
      uid = 983;
      group = "backup";
    };

    db = {
      inherit isSystemUser createHome description;
      uid = 982;
      group = "db";
    };

    home_assistant = {
      inherit isSystemUser createHome description;
      uid = 981;
      group = "home_assistant";
    };

    redis = {
      inherit isSystemUser createHome description;
      uid = 978;
      group = "redis";
    };

    unify = {
      inherit isSystemUser createHome description;
      uid = 977;
      group = "unify";
    };

    tdarr = {
      inherit isSystemUser createHome description;
      uid = 974;
      group = "media";
    };
  };
}
