{
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
      alloy
      container-guest
      nextcloud
      nginx
      nix-topology
      time
      timesyncd
      tmp-tmpfs
    ]
    ++ [
      self.inputs.nuschtos-modules.nixosModules.nextcloud
    ];

  networking.hostName = "nidoking";

  services = {
    nextcloud = {
      configureMemories = true;
      hostName = "nextcloud.rovacsek.com";
      settings = {
        datadirectory = "/srv/nextcloud";
      };
    };

    nginx = {
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
