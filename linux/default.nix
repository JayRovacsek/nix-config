{ self }:
let
  # Required build functions
  inherit (self.common.system) unstable-system;

  # Required package-sets
  inherit (self.common.package-sets) x86_64-linux-unstable aarch64-linux-unstable;

  inherit (self.lib.host)
    extend-host
    extend-microvm
    make-minimal-host
    make-minimal-microvm
    ;

  unstable-x86-base = make-minimal-host x86_64-linux-unstable unstable-system;
  unstable-aarch64-base = make-minimal-host aarch64-linux-unstable unstable-system;

  unstable-x86-microvm-base =
    (make-minimal-microvm x86_64-linux-unstable unstable-system).extendModules
      {
        modules = with self.nixosModules; [
          agenix
          alloy
          microvm-guest
          nix-topology
          time
          timesyncd
        ];
      };
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
  onix = extend-host unstable-aarch64-base "onix";
  wartortle = extend-host self.common.images.configurations.rpi5 "wartortle";
  wigglytuff = extend-host self.common.images.configurations.rpi4 "wigglytuff";

  ## WSL Configuration
  zubat = extend-host unstable-x86-base "zubat";

  ## W10 Migration Base Install Host
  grimer = extend-host unstable-x86-base "grimer";

  ## MicroVMs
  bellsprout = extend-microvm unstable-x86-microvm-base "bellsprout";
  igglybuff = extend-microvm unstable-x86-microvm-base "igglybuff";
  machop = extend-microvm unstable-x86-microvm-base "machop";
  magikarp = extend-microvm unstable-x86-microvm-base "magikarp";
  magnemite = extend-microvm unstable-x86-microvm-base "magnemite";
  magneton = extend-microvm unstable-x86-microvm-base "magneton";
  mankey = extend-microvm unstable-x86-microvm-base "mankey";
  meowth = extend-microvm unstable-x86-microvm-base "meowth";
  mr-mime = extend-microvm unstable-x86-microvm-base "mr-mime";
  nidoking = extend-microvm unstable-x86-microvm-base "nidoking";
  nidorina = extend-microvm unstable-x86-microvm-base "nidorina";
  nidorino = extend-microvm unstable-x86-microvm-base "nidorino";
  oddish = extend-microvm unstable-x86-microvm-base "oddish";
  poliwag = extend-microvm unstable-x86-microvm-base "poliwag";
  porygon = extend-microvm unstable-x86-microvm-base "porygon";
  slowpoke = extend-microvm unstable-x86-microvm-base "slowpoke";
  tentacruel = extend-microvm unstable-x86-microvm-base "tentacruel";
}
