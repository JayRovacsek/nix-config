let serviceName = "portainer";
in {
  inherit serviceName;
  autoStart = true;
  user = null;
  image = "portainer/portainer-ce:alpine";
  ports = [ "0.0.0.0:9000:9000" ];
  volumes = [
    "/var/run/docker.sock:/var/run/docker.sock"
    "/mnt/zfs/containers/portainer:/data"
    "/etc/passwd:/etc/passwd:ro"
  ];
  environment = { TZ = "Australia/Sydney"; };

  extraOptions = [ "--name=${serviceName}" "--network=bridge" ];
}
