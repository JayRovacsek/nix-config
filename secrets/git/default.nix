let
  keys = import ../../common/keys.nix { };

  git-host-keys = with keys; [
    jay-primary-key
    jay-secondary-key
  ];
in
{
  # SSH Signing Key
  "git-signing-key.age".publicKeys = git-host-keys;
  "git-signing-key-pub.age".publicKeys = git-host-keys;
}
