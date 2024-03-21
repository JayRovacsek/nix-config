{ config, flake, pkgs, self, ... }:
let
  inherit (self.lib) certificates;
  certificate-lib = certificates pkgs;
  inherit (certificate-lib) generate-self-signed;

  cert = generate-self-signed "nextcloud.rovacsek.com";
in {
  inherit flake;

  networking.hostName = "nidoking";

  users = {
    groups.nextcloud.gid = 10003;
    users = {
      nextcloud.uid = 988;
      root.hashedPassword =
        "$y$j9T$1WjHbjaCPVGEEGwuozTF/1$m/0ChZOXjfB5jTB23JMz1HuoiTrH3aw.XRLhpGB6hR6";
    };
  };

  microvm = {
    interfaces = [{
      type = "macvtap";
      id = config.networking.hostName;
      mac = "02:42:c0:a8:0a:03";
      macvtap = {
        link = "nextcloud";
        mode = "bridge";
      };
    }];

    mem = 6144;

    shares = [{
      # On the host
      source = "/srv/nextcloud";
      # In the MicroVM
      mountPoint = "/srv/nextcloud";
      tag = "nextcloud";
      proto = "virtiofs";
    }];

    vcpu = 4;
  };

  services = {
    nextcloud = {
      extraOptions.datadirectory = "/srv/nextcloud";
      hostName = "nextcloud.rovacsek.com";
    };

    nginx.virtualHosts."nextcloud.rovacsek.com" = {
      enableAuthelia = false;
      forceSSL = true;
      # TODO: remove self signed certificate in the future.
      sslCertificate = "${cert}/share/self-signed.crt";
      sslCertificateKey = "${cert}/share/privkey.key";
    };
  };

  system.stateVersion = "24.05";
}
