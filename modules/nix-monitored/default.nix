{ pkgs, self, ... }: {
  imports = [ self.inputs.nix-monitored.nixosModules.default ];

  nix.monitored = {
    enable = true;
    package = pkgs.nix-monitored.override { inherit (pkgs) nix; };
  };
}
