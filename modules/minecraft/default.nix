{
  environment.etc."minecraft/ops.json".text = ''
    [
      {
        "uuid": "UUID",
        "name": "NAME",
        "level": 4,
        "bypassesPlayerLimit": false
      }
    ]
  '';

  services.minecraft-server = {
    enable = true;
    eula = true;
    openFirewall = true;
    # whitelist = {
    #   A = "UUID";
    # };
    declarative = true;
    # Options as per: https://minecraft.fandom.com/wiki/Server.properties#Java_Edition_3
    serverProperties = {
      # peaceful (0)
      # easy (1)
      # normal (2)
      # hard (3)
      difficulty = 3;
      # survival (0)
      # creative (1)
      # adventure (2)
      # spectator (3)
      gamemode = 0;
      force-gamemode = true;
      max-players = 10;
      motd = "";
      white-list = true;
      enforce-whitelist = true;
      # Explicitly disable
      enable-rcon = false;
      # Timeout of 15mins AFK
      player-idle-timeout = 15;
      # Yeah. nah.
      snooper-enabled = false;
    };
    dataDir = "/etc/minecraft";
  };
}
