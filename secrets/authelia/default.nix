let
  primary-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFbU9DS6d3QwSVT+MTd58zB8pB4wTuw/5xckvqLbj13r";
  secondary-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH8yET3TtblG5YYGIkw4YxCUfsE0zHXnILbxamV5zz8R";
  keys = [
    primary-key
    secondary-key
  ];
in
{
  "jwt-secret-key.age".publicKeys = keys;
  "notifier-config.age".publicKeys = keys;
  "session-secret-key.age".publicKeys = keys;
  "storage-encryption-key.age".publicKeys = keys;
  "users.age".publicKeys = keys;
}
