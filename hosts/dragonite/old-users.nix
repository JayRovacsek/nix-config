{ self, ... }: {

  users = {
    users.media = {
      group = "media";
      isSystemUser = true;
      inherit (self.common.networking.services.media.user) uid;
    };
  };

  users.groups = {
    users.gid = 100;

    jellyfin = {
      gid = 10001;
      members = [ "jellyfin" ];
    };

    media = {
      inherit (self.common.networking.services.media.user) gid;
      members = [ "jay" "jellyfin" ];
    };
  };

  users.extraUsers.jellyfin = {
    createHome = false;
    description = "User account generated for running a specific service";
    group = "jellyfin";
    isSystemUser = true;
    uid = 998;
  };
}
