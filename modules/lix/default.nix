{ self, ... }:
{
  nixpkgs.overlays = [ self.overlays.lix ];
}
