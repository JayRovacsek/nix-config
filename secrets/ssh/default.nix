let
  primarySshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOigle2qwhrp1vOybRZlu4k3azwHA1/s61bjaDa54J9f";
  secondarySshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBlEvnIWwozY75HIpf/0ZPIjkkDk47uCL1nhqdDHUpED";
  sshKeys = [
    primarySshKey
    secondarySshKey
  ];
in
{
  # Secrets SSH keys - in this instance all hard-tokens so 
  # threat modelling would require physical access to fully
  # compromise anyway.
  # Here we use a prefix of $USERNAME- so we can dynamically 
  # generate suitable configs re; identity files and whatnot
  "type-a-1.age".publicKeys = sshKeys;
  "type-c-1.age".publicKeys = sshKeys;
  "type-a-2.age".publicKeys = sshKeys;
  "type-c-2.age".publicKeys = sshKeys;

  # SSH key used for remote builds
  "builder-id-ed25519.age".publicKeys = sshKeys;
}
