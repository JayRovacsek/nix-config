let
  primary-key =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINmMuGluJcKJy34iCttyCGuk9660XTcd150MPDfit64T";
  secondary-key =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAz/SCu9NWwfG5Bfv1oWYcJI9OdnipMSIGsaOPM5q5vz";
  keys = [ primary-key secondary-key ];
in { "hydra-github-token.age".publicKeys = keys; }
