{ self }:
{
  aws =
    {
      lib,
      pkgs,
      ...
    }:
    import ./aws.nix { inherit lib pkgs self; };
}
