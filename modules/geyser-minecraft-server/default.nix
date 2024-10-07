{
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  inherit (self.common.config.services) minecraft;

  # Fabric mods
  mods = {
    geyser = pkgs.fetchurl {
      url = "https://download.geysermc.org/v2/projects/geyser/versions/2.4.3/builds/683/downloads/fabric";
      hash = "sha256-LtJsNEjHfxHnBWU/O/jsbAClQXuoE+/eVfVf4LYDLAw=";
    };

    floodgate = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/bWrNNfkb/versions/wPa1pHZJ/Floodgate-Fabric-2.2.4-b36.jar";
      hash = "sha256-ifzWrdZ4KJoQpFspdhmOQ+FJtwVMaGtfy4XQOcewV0Y=";
    };

    # APIs
    # Depended by all mods.
    fabric-api = pkgs.fetchurl {
      url = "https://mediafilez.forgecdn.net/files/5750/140/fabric-api-0.105.0%2B1.21.1.jar";
      hash = "sha256-bwYWKJ1cR04WDxtsnNR/Mith581zmpd0CrCWmJHQ60U=";
    };
  };

  modpack = pkgs.runCommand "fabric-mods" { } ''
    mkdir $out
    ${builtins.concatStringsSep "\n" (
      lib.mapAttrsToList (name: mod: ''
        ln -sf ${mod} $out/${name}.jar
      '') mods
    )}
  '';

  floodgate-config = pkgs.writers.writeYAML "config.yml" (import ./floodgate-config.nix);
  geyser-config = pkgs.writers.writeYAML "config.yml" (
    import ./geyser-config.nix { inherit self; }
  );
in
{
  imports = [
    self.inputs.nix-minecraft.nixosModules.minecraft-servers
  ];

  nixpkgs.overlays = [ self.inputs.nix-minecraft.overlays.default ];

  networking.firewall = {
    allowedTCPPorts = [
      minecraft.java-port
    ];
    allowedUDPPorts = [ minecraft.bedrock-port ];
  };

  services.minecraft-server = {
    declarative = true;
    enable = true;
    eula = true;
    jvmOpts = "-Xms1G -Xmx2G";
    openFirewall = true;
    package = pkgs.fabric-server;

    serverProperties = {
      accepts-transfers = false;
      allow-flight = false;
      allow-nether = true;
      broadcast-console-to-ops = true;
      broadcast-rcon-to-ops = true;
      bug-report-link = "";
      difficulty = "easy";
      enable-command-block = false;
      enable-jmx-monitoring = false;
      enable-query = false;
      enable-rcon = false;
      enable-status = true;
      enforce-secure-profile = true;
      entity-broadcast-range-percentage = 100;
      force-gamemode = false;
      function-permission-level = 2;
      gamemode = "creative";
      generate-structures = true;
      hardcore = false;
      hide-online-players = false;
      initial-disabled-packs = "";
      initial-enabled-packs = "vanilla,fabric,fabric-convention-tags-v2";
      level-seed = "";
      log-ips = true;
      max-chained-neighbor-updates = 1000000;
      max-players = 5;
      max-tick-time = 60000;
      max-world-size = 29999984;
      motd = "Minecraft Server";
      network-compression-threshold = 256;
      online-mode = true;
      op-permission-level = 4;
      player-idle-timeout = 0;
      prevent-proxy-connections = false;
      pvp = false;
      rate-limit = 0;
      region-file-compression = "deflate";
      require-resource-pack = false;
      resource-pack = "";
      resource-pack-id = "";
      resource-pack-prompt = "";
      resource-pack-sha1 = "";
      server-ip = "";
      server-port = minecraft.java-port;
      simulation-distance = 10;
      spawn-animals = true;
      spawn-monsters = true;
      spawn-npcs = true;
      spawn-protection = 0;
      sync-chunk-writes = true;
      text-filtering-config = "";
      tick-distance = 12;
      use-native-transport = true;
      view-distance = 10;
    };
  };

  systemd.services.minecraft-server = {
    restartIfChanged = true;

    preStart = lib.mkAfter ''
      dataDir=${config.services.minecraft-server.dataDir}

      # Inject mods
      if [[ -d $dataDir/mods && ! -L $dataDir/mods ]]; then
        ${pkgs.coreutils}/bin/mv $dataDir/mods{,.old}
      fi
      ${pkgs.coreutils}/bin/ln -Tsf ${modpack} $dataDir/mods

      # Ensure plugin configurations match our expectations
      ${pkgs.coreutils}/bin/mkdir -p $dataDir/config/Geyser-Fabric
      ${pkgs.coreutils}/bin/mkdir -p $dataDir/config/floodgate
      ${pkgs.coreutils}/bin/cat ${geyser-config} > $dataDir/config/Geyser-Fabric/config.yml
      ${pkgs.coreutils}/bin/cat ${floodgate-config} > $dataDir/config/floodgate/config.yml
    '';
  };
}
