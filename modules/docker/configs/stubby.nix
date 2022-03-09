rec {
  image = "mvance/stubby:latest";
  serviceName = "stubby";
  ports = [ "8053:8053/udp" ];
  volumes = [ "/etc/stubby:/etc/stubby:rw" ];
  environment = { TZ = "Australia/Sydney"; };
  extraOptions =
    [ "--network=host" "--restart=unless-stopped" "--name=${serviceName}" ];
}
