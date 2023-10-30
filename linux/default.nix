{ self }:
let

  # Required build functions
  inherit (self.common.system) unstable-system bleeding-edge-system;

  # Required package-sets
  inherit (self.common.package-sets)
    x86_64-linux-unstable aarch64-linux-unstable aarch64-linux-bleeding-edge;

  inherit (self.lib.host) make-host;
in {
  # SD Installer Images / Configs
  # TEMPORARILY DISABLED
  # rpi1 = import ../common/images/rpi1.nix { inherit self; };
  # rpi2 = import ../common/images/rpi2.nix { inherit self; };

  # Cloud Base Images
  amazon = import ../common/images/amazon.nix { inherit self; };
  linode = import ../common/images/linode.nix { inherit self; };
  oracle = import ../common/images/oracle.nix { inherit self; };

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
  cloyster = make-host x86_64-linux-unstable "cloyster-linux" unstable-system;
  dragonite = make-host x86_64-linux-unstable "dragonite" unstable-system;
  gastly = make-host x86_64-linux-unstable "gastly" unstable-system;
  jigglypuff = make-host aarch64-linux-unstable "jigglypuff" unstable-system;
  wigglytuff =
    make-host aarch64-linux-bleeding-edge "wigglytuff" bleeding-edge-system;

  ## WSL Configuration
  zubat = make-host x86_64-linux-unstable "zubat" unstable-system;

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
