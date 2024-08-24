{
  config,
  lib,
  self,
  ...
}:
let
  inherit (self.common.config.services) openvpn;
in
{
  age = {
    identityPaths = [ "/agenix/id-ed25519-openvpn-primary" ];

    secrets = {
      ca-cert.file = ../../secrets/openvpn/ca-cert.age;
      dh2048-pem.file = ../../secrets/openvpn/dh2048-pem.age;
      server-cert.file = ../../secrets/openvpn/server-cert.age;
      server-key.file = ../../secrets/openvpn/server-key.age;
      ta-key.file = ../../secrets/openvpn/ta-key.age;
    };
  };

  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  networking = {
    firewall = {
      allowedUDPPorts = lib.optionals (openvpn.protocol == "udp") [ openvpn.port ];
      allowedTCPPorts = lib.optionals (openvpn.protocol == "tcp") [ openvpn.port ];
    };
    nat = {
      enable = true;
      # Default interface name
      internalInterfaces = [ "tun0" ];
      # Default interface name when setting usePredictableInterfaceNames = false;
      externalInterface = "eth0";
    };
  };

  services.openvpn.servers.server = {
    config = ''
      # Which TCP/UDP port should OpenVPN listen on?
      # If you want to run multiple OpenVPN instances
      # on the same machine, use a different port
      # number for each one.  You will need to
      # open up this port on your firewall.
      port ${builtins.toString openvpn.port}

      # TCP or UDP server?
      proto ${openvpn.protocol}

      # "dev tun" will create a routed IP tunnel,
      # "dev tap" will create an ethernet tunnel.
      # Use "dev tap0" if you are ethernet bridging
      # and have precreated a tap0 virtual interface
      # and bridged it with your ethernet interface.
      # If you want to control access policies
      # over the VPN, you must create firewall
      # rules for the TUN/TAP interface.
      # On non-Windows systems, you can give
      # an explicit unit number, such as tun0.
      # On Windows, use "dev-node" for this.
      # On most systems, the VPN will not function
      # unless you partially or fully disable/open
      # the firewall for the TUN/TAP interface.
      dev tun

      # SSL/TLS root certificate (ca), certificate
      # (cert), and private key (key).  Each client
      # and the server must have their own cert and
      # key file.  The server and all clients will
      # use the same ca file.
      #
      # See the "easy-rsa" project at
      # https://github.com/OpenVPN/easy-rsa
      # for generating RSA certificates
      # and private keys.  Remember to use
      # a unique Common Name for the server
      # and each of the client certificates.
      #
      # Any X509 key management system can be used.
      # OpenVPN can also use a PKCS #12 formatted key file
      # (see "pkcs12" directive in man page).
      #
      # If you do not want to maintain a CA
      # and have a small number of clients
      # you can also use self-signed certificates
      # and use the peer-fingerprint option.
      # See openvpn-examples man page for a
      # configuration example.
      ca ${config.age.secrets.ca-cert.path}
      cert ${config.age.secrets.server-cert.path}
      key ${config.age.secrets.server-key.path}

      # Diffie hellman parameters.
      # Generate your own with:
      #   openssl dhparam -out dh2048.pem 2048
      dh ${config.age.secrets.dh2048-pem.path}

      # Network topology
      # Should be subnet (addressing via IP)
      # unless Windows clients v2.0.9 and lower have to
      # be supported (then net30, i.e. a /30 per client)
      # Defaults to net30 (not recommended)
      topology subnet

      # Configure server mode and supply a VPN subnet
      # for OpenVPN to draw client addresses from.
      # The server will take 10.8.0.1 for itself,
      # the rest will be made available to clients.
      # Each client will be able to reach the server
      # on 10.8.0.1. Comment this line out if you are
      # ethernet bridging. See the man page for more info.
      server 10.8.0.0 255.255.255.0

      # Maintain a record of client <-> virtual IP address
      # associations in this file.  If OpenVPN goes down or
      # is restarted, reconnecting clients can be assigned
      # the same virtual IP address from the pool that was
      # previously assigned.
      ifconfig-pool-persist ipp.txt

      # The keepalive directive causes ping-like
      # messages to be sent back and forth over
      # the link so that each side knows when
      # the other side has gone down.
      # Ping every 10 seconds, assume that remote
      # peer is down if no ping received during
      # a 120 second time period.
      keepalive 10 120

      # For extra security beyond that provided
      # by SSL/TLS, create an "HMAC firewall"
      # to help block DoS attacks and UDP port flooding.
      #
      # Generate with:
      #   openvpn --genkey tls-auth ta.key
      #
      # The server and each client must have
      # a copy of this key.
      # The second parameter should be '0'
      # on the server and '1' on the clients.
      tls-auth ${config.age.secrets.ta-key.path} 0 # This file is secret

      cipher AES-256-GCM

      auth SHA256

      # The maximum number of concurrently connected
      # clients we want to allow.
      max-clients 2

      # The persist options will try to avoid
      # accessing certain resources on restart
      # that may no longer be accessible because
      # of the privilege downgrade.
      persist-key
      persist-tun

      # Output a short status file showing
      # current connections, truncated
      # and rewritten every minute.
      status openvpn-status.log

      # Set the appropriate level of log
      # file verbosity.
      #
      # 0 is silent, except for fatal errors
      # 4 is reasonable for general usage
      # 5 and 6 can help to debug connection problems
      # 9 is extremely verbose
      verb 3

      # Silence repeating messages.  At most 20
      # sequential messages of the same message
      # category will be output to the log.
      mute 20

      # Notify the client that when the server restarts so it
      # can automatically reconnect.
      explicit-exit-notify 1
    '';
  };

}
