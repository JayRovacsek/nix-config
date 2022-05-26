let
  primaryKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOigle2qwhrp1vOybRZlu4k3azwHA1/s61bjaDa54J9f";
  secondaryKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOEovGIk8AE7nM76xwGc7AmryAX3EdoL5qAtEs2sItDE";
  keys = [ primaryKey secondaryKey ];
in { "authelia_users_database.yaml.age".publicKeys = keys; }
