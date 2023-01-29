{ self }:
let
  inherit (self) inputs;

  # Package Sets
  inherit (self.inputs) stable unstable;

  # Extra modules
  inherit (self.inputs)
    agenix microvm nixos-generators nixos-hardware nixos-wsl;

  # This is required for any system needing to reference the flake itself from
  # within the nixosSystem config. It will be available as an argument to the 
  # config as "flake" if used as defined below
  inherit (self.common) users options;

  inherit (self.common.system) stable-system unstable-system;

  inherit (self.common.package-sets)
    x86_64-linux-stable x86_64-linux-unstable aarch64-linux-stable
    aarch64-linux-unstable;

in {
  # SD Installer Images / Configs
  rpi1 = import ../common/images/rpi1.nix { inherit self; };
  rpi2 = import ../common/images/rpi2.nix { inherit self; };

  # Hosts
  alakazam = let
    inherit (x86_64-linux-unstable) system identifier pkgs;
    base = self.common.modules.${identifier};
    modules = base
      ++ [ ../hosts/alakazam microvm.nixosModules.host agenix.nixosModule ];
  in unstable-system { inherit system pkgs modules; };

  gastly = let
    inherit (x86_64-linux-unstable) system identifier pkgs;
    base = self.common.modules.${identifier};
    modules = base ++ [ ../hosts/gastly agenix.nixosModule ];
  in unstable.lib.nixosSystem { inherit system pkgs modules; };

  dragonite = let
    inherit (x86_64-linux-stable) system identifier pkgs;
    base = self.common.modules.${identifier};
    modules = base
      ++ [ ../hosts/dragonite microvm.nixosModules.host agenix.nixosModule ];
  in stable.lib.nixosSystem { inherit system pkgs modules; };

  jigglypuff = let
    inherit (aarch64-linux-stable) system identifier pkgs;
    base = self.common.modules.${identifier};
    modules = base ++ [ ../hosts/jigglypuff agenix.nixosModule ];
  in stable.lib.nixosSystem { inherit system pkgs modules; };

  wigglytuff = let
    inherit (aarch64-linux-unstable) system identifier pkgs;
    base = self.common.modules.${identifier};
    modules = base ++ [
      ../hosts/wigglytuff
      agenix.nixosModule
      nixos-hardware.nixosModules.raspberry-pi-4
    ];
  in unstable.lib.nixosSystem { inherit system pkgs modules; };

  ## WSL Configuration

  zubat = let
    inherit (x86_64-linux-stable) system identifier pkgs;
    base = self.common.modules.${identifier};
    modules = base
      ++ [ ../hosts/zubat nixos-wsl.nixosModules.wsl agenix.nixosModule ];
  in stable.lib.nixosSystem { inherit system pkgs modules; };

  ## MICROVMS

  igglybuff = let
    inherit (x86_64-linux-unstable) system identifier pkgs;
    base = self.common.modules.${identifier};
    modules = base
      ++ [ microvm.nixosModules.microvm ../hosts/igglybuff agenix.nixosModule ];
  in unstable-system { inherit system pkgs modules; };

  aipom = let
    inherit (x86_64-linux-unstable) system identifier pkgs;
    base = self.common.modules.${identifier};
    modules = base
      ++ [ microvm.nixosModules.microvm ../hosts/aipom agenix.nixosModule ];
  in unstable-system { inherit system pkgs modules; };
}
