let portainerUser = import ../../../users/service-accounts/portainer.nix;
in {
  autoStart = true;
  image = "portainer/portainer-ce:alpine";
  serviceName = "portainer";
  ports = [ "0.0.0.0:9000:9000" ];
  volumes = [
    "/var/run/docker.sock:/var/run/docker.sock"
    "/mnt/zfs/containers/portainer:/data"
    "/etc/passwd:/etc/passwd:ro"
  ];
  environment = { TZ = "Australia/Sydney"; };
  extraOptions = [
    "--restart=always"
    "--network=bridge"
    "--user ${builtins.toString portainerUser.uid}:${
      builtins.toString portainerUser.group.id
    }"
  ];
}
