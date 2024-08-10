let
  # TODO: rekey with new headscale keys
  primaryHeadscaleKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN6tfWXvehhGzY0Z8r5Jx9V41UGDQQ2wOA1U163VQmlb";
  secondaryHeadscaleKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFIUpkvOZt0Tc7tsFyOYLXJGVQORaheEPJe37RzR+FBi";
  headscaleKeys = [
    primaryHeadscaleKey
    secondaryHeadscaleKey
  ];
in
{
  ## Headscale config keys
  "wg-private-key.age".publicKeys = headscaleKeys;
  "tls-crt.age".publicKeys = headscaleKeys;
  "tls-key.age".publicKeys = headscaleKeys;
}
