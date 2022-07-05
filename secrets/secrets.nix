let
  primaryKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOigle2qwhrp1vOybRZlu4k3azwHA1/s61bjaDa54J9f";
  secondaryKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOEovGIk8AE7nM76xwGc7AmryAX3EdoL5qAtEs2sItDE";
  keys = [ primaryKey secondaryKey ];
in {
  # need to re-do these to only use hyphens. what was I even thinking below.
  "headscale-dns-preauth-key.age".publicKeys = keys;
  "headscale-db-password.age".publicKeys = keys;
  "headscale-private-key.age".publicKeys = keys;
  "jay-id-ed25519-sk-type-a-1.age".publicKeys = keys;
  "jay-id-ed25519-sk-type-c-1.age".publicKeys = keys;
  "jay-id-ed25519-sk-type-a-2.age".publicKeys = keys;
  "jay-id-ed25519-sk-type-c-2.age".publicKeys = keys;
}
