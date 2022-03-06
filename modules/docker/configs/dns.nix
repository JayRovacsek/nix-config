let
  piholeConfig = import ./pihole.nix;
  stubbyConfig = import ./stubby.nix;
in {
  virtualisation.oci-containers = {
    containers = { } // piholeConfig // stubby;
  };
}
