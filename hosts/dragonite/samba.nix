{
  # This file requires the addition of the samba module
  # to enable shares
  services.samba.shares = {
    isos = {
      path = "/mnt/zfs/isos";
      browseable = "yes";
      "read only" = true;
      "guest ok" = "yes";
      comment = "Public ISO Share";
    };
    games = {
      path = "/mnt/zfs/games/files";
      browseable = "yes";
      "read only" = true;
      "guest ok" = "yes";
      comment = "Public Game Files";
    };
  };
}
