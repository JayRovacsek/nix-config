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
    package-set = x86_64-linux-unstable;
    name = "ditto";
    builder = unstable-system;
    extra-modules = [ ];
  };

  # Cloud Instances
  diglett = mkHost {
    package-set = x86_64-linux-unstable;
    name = "diglett";
    builder = unstable-system;
    extra-modules = [ ];
  };

  butterfree = mkHost {
    package-set = x86_64-linux-unstable;
    name = "butterfree";
    builder = unstable-system;
    extra-modules = [ ];
  };

  # Testing Instances
  mew = mkHost {
    package-set = x86_64-linux-unstable;
    name = "mew";
    builder = unstable-system;
    extra-modules = [ ];
  };

  # Hosts
  alakazam = mkHost {
    package-set = x86_64-linux-unstable;
    name = "alakazam";
    builder = unstable-system;
    extra-modules = [ ];
  };

  cloyster = mkHost {
    package-set = x86_64-linux-unstable;
    name = "cloyster";
    builder = unstable-system;
    extra-modules = [ ];
  };

  dragonite = mkHost {
    package-set = x86_64-linux-unstable;
    name = "dragonite";
    builder = unstable-system;
    extra-modules = [ ];
  };

  gastly = mkHost {
    package-set = x86_64-linux-unstable;
    name = "gastly";
    builder = unstable-system;
    extra-modules = [ ];
  };

  jigglypuff = mkHost {
    package-set = aarch64-linux-unstable;
    name = "jigglypuff";
    builder = unstable-system;
    extra-modules = [ ];
  };

  wigglytuff = mkHost {
    package-set = aarch64-linux-bleeding-edge;
    name = "wigglytuff";
    builder = bleeding-edge-system;
    extra-modules = [ ];
  };

  ## WSL Configuration
  zubat = mkHost {
    package-set = x86_64-linux-unstable;
    name = "zubat";
    builder = unstable-system;
    extra-modules = [ ];
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
