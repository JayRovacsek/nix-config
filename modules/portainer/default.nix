{ config, self, ... }:
let
  inherit (self.lib) docker users;

  name = "portainer";

  # Actual constructs used to generate useful config
  portainer-user = users.generate-service-user {
    inherit name;
    uid = 2002;
    group = {
      inherit name;
      gid = 10000;
      members = [ "${name}" ];
    };
    extraGroups = [ "docker" ];
  };

in
{
  virtualisation.oci-containers.containers = docker.generate-config {
    serviceName = name;
    autoStart = true;
    user = "${
      builtins.toString config.users.users.${name}.uid
    }:${builtins.toString config.ids.gids.docker}";
    image = "${name}/${name}-ce:alpine";
    ports = [ "0.0.0.0:9000:9000" ];
    volumes = [
      "/var/run/docker.sock:/var/run/docker.sock"
      "/var/lib/${name}:/data"
    ];
    environment.TZ = "Australia/Sydney";

    extraOptions = [
      "--name=${name}"
      "--network=bridge"
    ];
  };

  users.extraUsers = portainer-user.extraUsers;
  users.extraGroups = portainer-user.extraGroups;

  networking.firewall.allowedTCPPorts = [ 9000 ];
}
