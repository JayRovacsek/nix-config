{
  config,
  pkgs,
  self,
  ...
}:
let
  inherit (self.lib) certificates;
  certificate-lib = certificates pkgs;
  inherit (certificate-lib) generate-self-signed;

  cert = generate-self-signed "nextcloud.rovacsek.com";
in
{

  imports =
    with self.nixosModules;
    [
      agenix
      grafana-agent
      microvm-guest
      nextcloud
      nginx
      nix-topology
      time
      timesyncd
      tmp-tmpfs
    ]
    ++ [ self.inputs.sandro-nixos-modules.nixosModule ];

  microvm = {
    interfaces = [
      {
        type = "macvtap";
        id = config.networking.hostName;
        mac = "02:42:c0:a8:0a:03";
        macvtap = {
          link = "nextcloud";
          mode = "bridge";
        };
      }
    ];

    mem = 8192;

    shares = [
      {
        # On the host
        source = "/srv/nextcloud";
        # In the MicroVM
        mountPoint = "/srv/nextcloud";
        tag = "nextcloud";
        proto = "virtiofs";
      }
    ];

    vcpu = 4;
  };

  networking.hostName = "nidoking";

  services = {
    nextcloud = {
      configureMemories = true;
      configureRecognize = true;
      hostName = "nextcloud.rovacsek.com";
      settings.datadirectory = "/srv/nextcloud";
    };

    nginx = {
      statusPage = true;

      virtualHosts."nextcloud.rovacsek.com" = {
        enableAuthelia = false;
        forceSSL = true;
        # TODO: remove self signed certificate in the future.
        sslCertificate = "${cert}/share/self-signed.crt";
        sslCertificateKey = "${cert}/share/privkey.key";
      };
    };
  };

  system.stateVersion = "24.05";

  users = {
    groups.nextcloud.gid = 10003;
    users.nextcloud.uid = 988;
  };
}
