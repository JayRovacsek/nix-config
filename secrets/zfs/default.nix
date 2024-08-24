let
  primary-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDMrW8bV9R39pkLbdXv4Q2McLyCnIhRBHkBtv1TFD8++";
  secondary-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGQtWe4cz/6WlcK0rn0xEIRxBF4lUyCNt28ZpHl5ANev";
  keys = [
    primary-key
    secondary-key
  ];
in
{
  "dragonite-fde-key.age".publicKeys = keys;
}
