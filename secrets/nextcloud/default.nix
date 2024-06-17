let
  primary-key =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOpa1TCf0BfVrW6hEcSQXRehR4LMu/UgWRu4gUGnINxs";
  secondary-key =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIICXujd1vnKwxIJu2Pwp9FFcy3+pIpGwR424m4nLees5";
  keys = [ primary-key secondary-key ];
in {
  "admin-pass.age".publicKeys = keys;
  "secret-file.age".publicKeys = keys;
  "exporter-token.age".publicKeys = keys;
}
