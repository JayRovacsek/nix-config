let
  keys = import ../../common/keys.nix { };
in
{
  "server-pass-file.age".publicKeys = with keys; [
    porygon-primary-key
    porygon-secondary-key
  ];
}
