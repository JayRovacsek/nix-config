let
  primary-key =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID9mQgnIqz3H+eTHQE4zsbAn8IFVUjVGULzX3cjS+Nob";
  secondary-key =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE28sKj6QXIgWvR5QILAQ8nRpA6GeFk2PF/Y8OCrSn+6";
  keys = [ primary-key secondary-key ];
in { "hydra-github-token.age".publicKeys = keys; }
