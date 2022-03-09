let piholeUserConfig = import ../../../users/service-accounts/pihole.nix;
in rec {
  image = "pihole/pihole:latest";
  serviceName = "pihole";
  ports = [ "53:53/tcp" "53:53/udp" "67:67/udp" "80:80/tcp" "444:443/tcp" ];
  volumes = [
    "/etc/pihole:/etc/pihole:rw"
    "/etc/passwd:/etc/passwd:ro"
    "/etc/pihole/dnsmasq.d:/etc/dnsmasq.d:rw"
  ];
  environment = {
    TZ = "Australia/Sydney";
    PIHOLE_DNS_ = "127.0.0.1#8053";
    DNSSEC = "true";
    DNS_BOGUS_PRIV = "false";
    DNS_FQDN_REQUIRED = "true";
    DHCP_ACTIVE = "false";
    DNSMASQ_LISTENING = "all";
    DNSMASQ_USER = "pihole";
    WEBPASSWORD = "password";
  };
  extraOptions = [
    "--network=podman"
    "--name=${serviceName}"
    ''
      --user="${builtins.toString piholeUserConfig.uid}:${
        builtins.toString piholeUserConfig.group.id
      }"''
    "--cap-add=CAP_NET_BIND_SERVICE"
  ];
}
