{ self }:
let
  # Required build functions
  inherit (self.common.system) unstable-system;

  # Required package-sets
  inherit (self.common.package-sets)
    x86_64-linux-unstable
    x86_64-linux-cuda-unstable
    aarch64-linux-unstable
    ;

  inherit (self.lib.host)
    extend-host
    extend-host-as-container
    make-minimal-host
    ;

  unstable-x86-base = make-minimal-host x86_64-linux-unstable unstable-system;
  unstable-x86-cuda-base = make-minimal-host x86_64-linux-cuda-unstable unstable-system;
  unstable-aarch64-base = make-minimal-host aarch64-linux-unstable unstable-system;

  inherit (self.common.images.configurations)
    rpi4
    rpi5
    ;
in
{
  # Cloud and hardware specific configurations
  inherit (self.common.images.configurations)
    amazon
    linode
    oracle
    rpi4
    rpi5
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
  alakazam = extend-host unstable-x86-cuda-base "alakazam";
  dragonite = extend-host unstable-x86-cuda-base "dragonite";
  gastly = extend-host unstable-x86-base "gastly";
  ivysaur = extend-host rpi5 "ivysaur";
  jigglypuff = extend-host unstable-aarch64-base "jigglypuff";
  onix = extend-host unstable-x86-base "onix";
  wartortle = extend-host rpi5 "wartortle";
  wigglytuff = extend-host rpi4 "wigglytuff";

  # Containers
  bellsprout = extend-host-as-container unstable-x86-base "bellsprout";
  igglybuff = extend-host-as-container unstable-x86-base "igglybuff";
  machop = extend-host-as-container unstable-x86-base "machop";
  magikarp = extend-host-as-container unstable-x86-base "magikarp";
  magnemite = extend-host-as-container unstable-x86-base "magnemite";
  magneton = extend-host-as-container unstable-x86-base "magneton";
  mankey = extend-host-as-container unstable-x86-base "mankey";
  meowth = extend-host-as-container unstable-x86-base "meowth";
  mr-mime = extend-host-as-container unstable-x86-base "mr-mime";
  natu = extend-host-as-container unstable-x86-base "natu";
  nidoking = extend-host-as-container unstable-x86-base "nidoking";
  nidorina = extend-host-as-container unstable-x86-base "nidorina";
  nidorino = extend-host-as-container unstable-x86-base "nidorino";
  oddish = extend-host-as-container unstable-x86-base "oddish";
  poliwag = extend-host-as-container unstable-x86-base "poliwag";
  porygon = extend-host-as-container unstable-x86-base "porygon";
  slowpoke = extend-host-as-container unstable-x86-base "slowpoke";
  tentacruel = extend-host-as-container unstable-x86-base "tentacruel";

  ## WSL Configuration
  zubat = extend-host unstable-x86-base "zubat";

  ## W10 Migration Base Install Host
  grimer = extend-host unstable-x86-base "grimer";
}
