{ self }:
let
  # Required build functions
  inherit (self.common.system) unstable-system;

  # Required package-sets
  inherit (self.common.package-sets) x86_64-linux-unstable aarch64-linux-unstable;

  inherit (self.lib.host) make-host make-microvm;
in
{
  # Cloud and hardware specific configurations
  inherit (self.common.images.configurations)
    amazon
    linode
    oracle
    rpi1
    rpi2
    ;

  # Base Configuration Hosts
  # Above cloud base images all inherit from this configuration effectively 
  # so exposure here is more to give a consistent base and be enabled to add tweaks
  # at a level in which it is inherited from all base-images
  # This host otherwise is simply a very base headless install
  ditto = make-host x86_64-linux-unstable "ditto" unstable-system;

  # Cloud Instances
  diglett = make-host x86_64-linux-unstable "diglett" unstable-system;
  butterfree = make-host x86_64-linux-unstable "butterfree" unstable-system;

  # Testing Instances
  mew = make-host x86_64-linux-unstable "mew" unstable-system;

  # Hosts
  alakazam = make-host x86_64-linux-unstable "alakazam" unstable-system;
  dragonite = make-host x86_64-linux-unstable "dragonite" unstable-system;
  gastly = make-host x86_64-linux-unstable "gastly" unstable-system;
  jigglypuff = make-host aarch64-linux-unstable "jigglypuff" unstable-system;
  wigglytuff = make-host aarch64-linux-unstable "wigglytuff" unstable-system;

  ## WSL Configuration
  zubat = make-host x86_64-linux-unstable "zubat" unstable-system;

  ## MicroVMs
  bellsprout = make-microvm x86_64-linux-unstable "bellsprout" unstable-system;
  igglybuff = make-microvm x86_64-linux-unstable "igglybuff" unstable-system;
  machop = make-microvm x86_64-linux-unstable "machop" unstable-system;
  magikarp = make-microvm x86_64-linux-unstable "magikarp" unstable-system;
  mankey = make-microvm x86_64-linux-unstable "mankey" unstable-system;
  meowth = make-microvm x86_64-linux-unstable "meowth" unstable-system;
  mr-mime = make-microvm x86_64-linux-unstable "mr-mime" unstable-system;
  nidoking = make-microvm x86_64-linux-unstable "nidoking" unstable-system;
  nidorina = make-microvm x86_64-linux-unstable "nidorina" unstable-system;
  nidorino = make-microvm x86_64-linux-unstable "nidorino" unstable-system;
  poliwag = make-microvm x86_64-linux-unstable "poliwag" unstable-system;
  porygon = make-microvm x86_64-linux-unstable "porygon" unstable-system;
  slowpoke = make-microvm x86_64-linux-unstable "slowpoke" unstable-system;
}
