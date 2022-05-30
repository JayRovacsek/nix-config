let
  primaryKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOigle2qwhrp1vOybRZlu4k3azwHA1/s61bjaDa54J9f";
  secondaryKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOEovGIk8AE7nM76xwGc7AmryAX3EdoL5qAtEs2sItDE";
  keys = [ primaryKey secondaryKey ];
in {
  "ssh_config.age".publicKeys = keys;
  "id_ed25519_sk_type_a_1.age".publicKeys = keys;
  "id_ed25519_sk_type_a_1.pub.age".publicKeys = keys;
  "id_ed25519_sk_type_c_1.age".publicKeys = keys;
  "id_ed25519_sk_type_c_1.pub.age".publicKeys = keys;
  "id_ed25519_sk_type_a_2.age".publicKeys = keys;
  "id_ed25519_sk_type_a_2.pub.age".publicKeys = keys;
  "id_ed25519_sk_type_c_2.age".publicKeys = keys;
  "id_ed25519_sk_type_c_2.pub.age".publicKeys = keys;
}
