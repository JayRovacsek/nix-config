let
  primary-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMxQ1OuDRZb/VtVe6PWhAAPWb5wlwCo0daguzHMy0IjT";
  secondary-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIUJYlwJ1//8bzSCptyqc810HpJVjO0btPVwL/pVhHix";
  keys = [
    primary-key
    secondary-key
  ];
in
{
  "api-key.age".publicKeys = keys;
}
