let
  primary-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHMu37RuwCTTgcrmf5fkwfWVOBR+6uQh6Q/Dy/+OLnBq";
  secondary-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJRJGr9G+K8DQkHFo6sptZgUym/TuvCD+en8i1DSFoS4";
  keys = [
    primary-key
    secondary-key
  ];
in
{
  "client-secret.age".publicKeys = keys;
  "cookie-secret.age".publicKeys = keys;
  "github-app-secret.age".publicKeys = keys;
  "oauth-secret.age".publicKeys = keys;
  "webhook-secret.age".publicKeys = keys;
  "workers-file.age".publicKeys = keys;
  "workers-password.age".publicKeys = keys;
}
