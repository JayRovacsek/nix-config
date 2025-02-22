_: {
  imports = [
    ../../options/modules/palworld
    ../../options/modules/steam
  ];

  services.palworld = {
    enable = true;
    dataDir = "/srv/games/servers/palworld/feb-2025";
  };
}
