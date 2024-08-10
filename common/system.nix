{ self }:
let
  inherit (self.inputs)
    bleeding-edge
    nixpkgs
    nix-darwin
    stable
    ;
in
{
  # Note that this does not mean a system that utilises unstable-system
  # is purely unstable, it can utilise stable package-sets for home-manager 
  # and/or remaining system config, this only governs the generation of
  # system configs via either the current unstable or stable.
  stable-system = stable.lib.nixosSystem;
  unstable-system = nixpkgs.lib.nixosSystem;
  bleeding-edge-system = bleeding-edge.lib.nixosSystem;

  darwin-system = nix-darwin.lib.darwinSystem;
}
