{
  config,
  lib,
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
    ++ [ self.inputs.nuschtos-modules.nixosModule ];

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

  nixpkgs.overlays = [
    self.overlays.exiftool-12-70
  ];

  services = {
    nextcloud = {
      configureMemories = true;
      hostName = "nextcloud.rovacsek.com";
      settings = {
        datadirectory = "/srv/nextcloud";
        # Handle for version requirement of current memories install
        # See also: https://github.com/NuschtOS/nixos-modules/blob/e28ac24205fc6e0a78889b790326f99ee594b718/modules/nextcloud.nix#L103C13-L103C60
        "memories.exiftool" = lib.mkForce (lib.getExe pkgs.exiftool-12-70);
      };
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
