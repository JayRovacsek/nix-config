let
  primaryAutheliaKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN6tfWXvehhGzY0Z8r5Jx9V41UGDQQ2wOA1U163VQmlb";
  secondaryAutheliaKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFIUpkvOZt0Tc7tsFyOYLXJGVQORaheEPJe37RzR+FBi";
  autheliaKeys = [ primaryAutheliaKey secondaryAutheliaKey ];
in {
  "jwt-secret-key.age".publicKeys = autheliaKeys;
  "session-secret-key.age".publicKeys = autheliaKeys;
  "storage-encryption-key.age".publicKeys = autheliaKeys;
}
