{ config, self, ... }:
let
  inherit (self.lib) docker users;

  name = "tdarr";

  # Actual constructs used to generate useful config
  tdarr-user = users.generate-service-user {
    inherit name;
    uid = 974;
    group = {
      inherit name;
      members = [ "${name}" ];
    };
    extraGroups = [ "media" ];
  };

in
{
  virtualisation.oci-containers.containers = docker.generate-config {
    serviceName = name;
    autoStart = true;
    user = builtins.toString config.users.users.${name}.uid;
    image = "haveagitgat/${name}:latest";
    ports = [
      "8265:8265"
      "8266:8266"
    ];
    volumes = [
      "/srv/containers/${name}/server:/app/server:rw"
      "/srv/containers/${name}/configs:/app/configs:rw"
      "/srv/containers/${name}/logs:/app/logs:rw"
      "/srv/movies:/movies:rw"
      "/srv/tv:/tv:rw"
      "/srv/music:/music:rw"
      "/transcode:/temp:rw"
    ];
    environment = {
      TZ = "Australia/NSW";
      PUID = 974;
      PGID = 10002;
      UMASK_SET = "002";
      serverIP = "0.0.0.0";
      serverPort = 8266;
      webUIPort = 8265;
    };

    extraOptions = [
      "--name=${name}"
      "--network=bridge"
    ];
  };
  users.extraUsers = tdarr-user.extraUsers;
  users.extraGroups = tdarr-user.extraGroups;

  networking.firewall.allowedTCPPorts = [
    8265
    8266
  ];
}
