let piholeUserConfig = import ../../../users/service-accounts/pihole.nix;
in rec {
  image = "pihole/pihole:latest";
  serviceName = "pihole";
  ports = [ "53:53/tcp" "53:53/udp" "80:80/tcp" ];
  volumes = [
    "/etc/pihole:/etc/pihole:rw"
    "/etc/pihole/dnsmasq.d:/etc/dnsmasq.d:rw"
    "/etc/passwd:/etc/passwd:ro"
  ];
  environment = {
    TZ = "Australia/Sydney";
    PIHOLE_DNS_ = "127.0.0.1#8053";
    DNSSEC = "true";
    DNS_BOGUS_PRIV = "true";
    DNS_FQDN_REQUIRED = "true";
    DHCP_ACTIVE = "false";
    DNSMASQ_LISTENING = "all";
    DNSMASQ_USER = "pihole";
    WEBPASSWORD = "password";
    WEBTHEME = "default-dark";
    FTLCONF_RESOLVE_IPV6 = "no";
    FTLCONF_SOCKET_LISTENING = "all";
    FTLCONF_NAMES_FROM_NETDB = "true";
    PIHOLE_UID = piholeUserConfig.uid;
    PIHOLE_GID = piholeUserConfig.group.id;
  };
  extraOptions = [
    "--name=${serviceName}"
    "--cap-add=CAP_NET_BIND_SERVICE"
    "--cap-add=CAP_SYS_NICE"
    "--cap-add=CAP_CHOWN"
    "--network=host"
    ''
      --user="${builtins.toString piholeUserConfig.uid}:${
        builtins.toString piholeUserConfig.group.id
      }"''
  ];
}
