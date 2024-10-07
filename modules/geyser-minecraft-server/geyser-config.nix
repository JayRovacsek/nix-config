{ self, ... }:
{
  above-bedrock-nether-building = false;
  add-non-bedrock-items = true;
  allow-custom-skulls = true;
  bedrock = {
    clone-remote-port = false;
    compression-level = 6;
    enable-proxy-protocol = false;
    motd1 = "Geyser";
    motd2 = "Another Geyser server.";
    port = self.common.config.services.minecraft.bedrock-port;
    server-name = "Geyser";
  };
  cache-images = 0;
  command-suggestions = true;
  config-version = 4;
  custom-skull-render-distance = 32;
  debug-mode = false;
  disable-bedrock-scaffolding = false;
  disable-compression = true;
  emote-offhand-workaround = "disabled";
  enable-proxy-connections = false;
  floodgate-key-file = "key.pem";
  force-resource-packs = true;
  forward-player-ping = false;
  legacy-ping-passthrough = false;
  log-player-ip-addresses = true;
  max-players = 100;
  max-visible-custom-skulls = 128;
  metrics.enabled = false;
  mtu = 1400;
  notify-on-new-bedrock-update = true;
  passthrough-motd = true;
  passthrough-player-counts = true;
  pending-authentication-timeout = 300;
  ping-passthrough-interval = 3;
  remote = {
    address = "auto";
    auth-type = "floodgate";
    forward-hostname = false;
    port = self.common.config.services.minecraft.java-port;
    use-proxy-protocol = false;
  };
  scoreboard-packet-threshold = 20;
  show-cooldown = "title";
  show-coordinates = true;
  unusable-space-block = "minecraft:barrier";
  use-direct-connection = true;
  xbox-achievements-enabled = false;
}
