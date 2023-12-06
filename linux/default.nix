{ self }:
let
  # Required build functions
  inherit (self.common.system) unstable-system bleeding-edge-system;

  # Required package-sets
  inherit (self.common.package-sets)
    x86_64-linux-unstable aarch64-linux-unstable aarch64-linux-bleeding-edge;

  inherit (self.lib.host) mkHost;
in {
  # Cloud and hardware specific configurations
  inherit (self.common.images.configurations) amazon linode oracle rpi1 rpi2;

  # Base Configuration Hosts
  # Above cloud base images all inherit from this configuration effectively 
  # so exposure here is more to give a consistent base and be enabled to add tweaks
  # at a level in which it is inherited from all base-images
  # This host otherwise is simply a very base headless install
  ditto = mkHost {
    builder = unstable-system;
    name = "ditto";
    package-set = x86_64-linux-unstable;
  };

  # Cloud Instances
  diglett = mkHost {
    builder = unstable-system;
    name = "diglett";
    package-set = x86_64-linux-unstable;
  };

  butterfree = mkHost {
    builder = unstable-system;
    name = "butterfree";
    package-set = x86_64-linux-unstable;
  };

  # Testing Instances
  mew = mkHost {
    builder = unstable-system;
    name = "mew";
    package-set = x86_64-linux-unstable;
  };

  # Hosts
  alakazam = mkHost {
    builder = unstable-system;
    name = "alakazam";
    package-set = x86_64-linux-unstable;
  };

  cloyster = mkHost {
    builder = unstable-system;
    name = "cloyster";
    package-set = x86_64-linux-unstable;
  };

  dragonite = mkHost {
    builder = unstable-system;
    name = "dragonite";
    package-set = x86_64-linux-unstable;
  };

  gastly = mkHost {
    builder = unstable-system;
    name = "gastly";
    package-set = x86_64-linux-unstable;
  };

  jigglypuff = mkHost {
    builder = unstable-system;
    name = "jigglypuff";
    package-set = aarch64-linux-unstable;
  };

  wigglytuff = mkHost {
    builder = bleeding-edge-system;
    name = "wigglytuff";
    package-set = aarch64-linux-bleeding-edge;
  };

  ## WSL Configuration
  zubat = mkHost {
    builder = unstable-system;
    name = "zubat";
    package-set = x86_64-linux-unstable;
  };

  ## MicroVMs
  ## TEMPORARILY DISABLED

  # igglybuff = let
  #   inherit (x86_64-linux-unstable) system identifier pkgs;
  #   base = self.common.modules.${identifier};
  #   modules = base ++ [ microvm.nixosModules.microvm ../hosts/igglybuff ];
  # in unstable-system { inherit system pkgs modules; };

  # aipom = let
  #   inherit (x86_64-linux-unstable) system identifier pkgs;
  #   base = self.common.modules.${identifier};
  #   modules = base ++ [ microvm.nixosModules.microvm ../hosts/aipom ];
  # in unstable-system { inherit system pkgs modules; };
}
