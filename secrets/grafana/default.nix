let
  keys = import ../../common/keys.nix { };

  mr-mime-keys = with keys; [
    mr-mime-primary-key
    mr-mime-secondary-key
  ];
in
{
  "admin-password.age".publicKeys = mr-mime-keys;
}
