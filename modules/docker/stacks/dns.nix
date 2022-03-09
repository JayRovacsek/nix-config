let
  piholeUserConfig = import ../../../users/service-accounts/pihole.nix;
  stubbyUserConfig = import ../../../users/service-accounts/stubby.nix;
  piholeDockerConfig = import ../configs/pihole.nix;
  stubbyDockerConfig = import ../configs/stubby.nix;

  # Helper functions for generating correct nix configs
  userFunction = import ../../../functions/service-user.nix;
  dockerFunction = import ../../../functions/docker.nix;

  # Actual constructs used to generate useful config
  piholeUser = userFunction { userConfig = piholeUserConfig; };
  stubbyUser = userFunction { userConfig = stubbyUserConfig; };
  pihole = dockerFunction { containerConfig = piholeDockerConfig; };
  stubby = dockerFunction { containerConfig = stubbyDockerConfig; };
in {
  virtualisation.oci-containers = {
    containers = pihole // stubby;
    backend = "podman";
  };
  users.extraUsers = piholeUser.extraUsers // stubbyUser.extraUsers;
  users.extraGroups = piholeUser.extraGroups // stubbyUser.extraGroups;

  environment.etc = {
    "stubby/stubby.yml".source = ''
      resolution_type: GETDNS_RESOLUTION_STUB
      dns_transport_list:
        - GETDNS_TRANSPORT_TLS
      tls_authentication: GETDNS_AUTHENTICATION_REQUIRED
      tls_query_padding_blocksize: 128
      edns_client_subnet_private: 1
      round_robin_upstreams: 1
      idle_timeout: 10000
      listen_addresses:
        - 0.0.0.0@8053
        - 0:0:0:0:0:0:0:0@8053

      upstream_recursive_servers:
        - address_data: 116.202.176.26
          tls_auth_name: "dot.libredns.gr"
        - address_data: 103.73.64.132
          tls_auth_name: "dot.au.ahadns.net"
        - address_data: 185.175.56.133
          tls_auth_name: "dot.no.ahadns.net"
        - address_data: 5.2.75.75
          tls_auth_name: "dot.nl.ahadns.net"
        - address_data: 185.213.26.187
          tls_auth_name: "dot.ny.ahadns.net"
        - address_data: 94.16.114.254
          tls_auth_name: "jabber-germany.de"'';
  };
}
