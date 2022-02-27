# Taking a lot of inspiration from: https://github.com/pgronkievitz/nixos-configurations/tree/main/modules/selfhosted
# This'll likely need more work though
let
  servicename = "servicename";
  shortname = "shortname";
in { containerConfig, ... }: {
  virtualisation.oci-containers = {
    containers = {
      "${servicename}" = {
        image = containerConfig.image ? "image";
        ports = [ "0:0/tcp" "0:0/udp" ] ++ containerConfig.ports;
        volumes = [ "/mnt/zfs/containers/${servicename}:/etc/${servicename}" ]
          ++ containerConfig.volumes;
        environment = {
          TZ = "Australia/Sydney";
        } // containerConfig.environment;
        extraOptions = [ "--some-option=extraOptions" ]
          ++ containerConfig.extraOptions;
      };
    };
  };
}
