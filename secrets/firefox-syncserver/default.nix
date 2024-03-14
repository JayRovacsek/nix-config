let
  primary-key =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJCQ4S6f6IhpR3M2gFENmKcwVeRh4kmIcw5krtzhmRZv";
  secondary-key =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE5EfLtxn30EYwJhUu7c4C5i3bhbYmqZM4UZJL7JnZHI";
  keys = [ primary-key secondary-key ];
in { "secrets.age".publicKeys = keys; }
