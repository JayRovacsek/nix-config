{ self }:
let
  # Required build functions
  inherit (self.common.system) unstable-system;

  # Required package-sets
  inherit (self.common.package-sets)
    x86_64-linux-unstable
    aarch64-linux-unstable
    ;

  inherit (self.lib.host)
    extend-host
    make-minimal-host
    ;

  unstable-x86-base = make-minimal-host x86_64-linux-unstable unstable-system;
  unstable-aarch64-base = make-minimal-host aarch64-linux-unstable unstable-system;
in
{
  # Cloud and hardware specific configurations
  inherit (self.common.images.configurations)
    amazon
    linode
    oracle
    rpi4
    ;

  # Base Configuration Hosts
  # Above cloud base images all inherit from this configuration effectively
  # so exposure here is more to give a consistent base and be enabled to add tweaks
  # at a level in which it is inherited from all base-images
  # This host otherwise is simply a very base headless install
  ditto = extend-host unstable-x86-base "ditto";

  # Cloud Instances
  diglett = extend-host unstable-x86-base "diglett";
  butterfree = extend-host unstable-x86-base "butterfree";

  # Testing Instances
  mew = extend-host unstable-x86-base "mew";

  # Hosts
  alakazam = extend-host unstable-x86-base "alakazam";
  dragonite = extend-host unstable-x86-base "dragonite";
  gastly = extend-host unstable-x86-base "gastly";
  ivysaur = extend-host self.common.images.configurations.rpi5 "ivysaur";
  jigglypuff = extend-host unstable-aarch64-base "jigglypuff";
  wartortle = extend-host self.common.images.configurations.rpi5 "wartortle";
  wigglytuff = extend-host self.common.images.configurations.rpi4 "wigglytuff";

  ## WSL Configuration
  zubat = extend-host unstable-x86-base "zubat";

  ## W10 Migration Base Install Host
  grimer = extend-host unstable-x86-base "grimer";
}
