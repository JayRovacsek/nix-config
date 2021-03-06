let
  primaryMetaKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKPwZZbNud2VumVJnLsLVWlCo0pNkKSyp+Ok5plXa9Gz";
  secondaryMetaKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBlEvnIWwozY75HIpf/0ZPIjkkDk47uCL1nhqdDHUpED";
  metaKeys = [ primaryMetaKey secondaryMetaKey ];

  primarySshKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOigle2qwhrp1vOybRZlu4k3azwHA1/s61bjaDa54J9f";
  secondarySshKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBlEvnIWwozY75HIpf/0ZPIjkkDk47uCL1nhqdDHUpED";
  sshKeys = [ primarySshKey secondarySshKey ];

  primaryWirelessKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFZl+B55kdAs3wZv8W2O0wy2mNuJv9MD7Y+Do9IGSf9q";
  secondaryWirelessKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF0KzuSlDoE1jkiGfhVI5/N1rbmpUjQCLmpprcQMr+NW  ";
  wirelessKeys = [ primaryWirelessKey secondaryWirelessKey ];

  primaryTailscaleKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFufEoK+LGcpNy7PnCih/LwwrjANruawcCzeh2INnZ0A";
  secondaryTailscaleKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPSITKapgYMXOYu/OeVznsQlRkrl6gScyuR9PA2z+hA7";
  tailscaleKeys = [ primaryTailscaleKey secondaryTailscaleKey ];
in {
  # Meta keys encrypt keys used to encrypt other secrets. Here we are
  # intentionally only deploying a single key of the pair so we can 
  # have confidence in the event of needing to roll secrets we can 
  # use our offline key in isolation, generate new secrets for the meta
  # keys and then roll with a new primary.
  # The above would be only predicated if someone has root which we're screwed anyway right?
  "meta-tailscale-primary-key.age".publicKeys = metaKeys;
  # "meta-tailscale-secondary-key.age".publicKeys = metaKeys;
  "meta-ssh-primary-key.age".publicKeys = metaKeys;
  # "meta-ssh-secondary-key.age".publicKeys = metaKeys;

  # Secrets related to tailscale/headscale
  ## Tailscale preauth keys
  "tailscale-dns-preauth-key.age".publicKeys = tailscaleKeys;
  "tailscale-download-preauth-key.age".publicKeys = tailscaleKeys;
  "tailscale-authelia-preauth-key.age".publicKeys = tailscaleKeys;
  "tailscale-nextcloud-preauth-key.age".publicKeys = tailscaleKeys;
  "tailscale-work-preauth-key.age".publicKeys = tailscaleKeys;
  "tailscale-log-preauth-key.age".publicKeys = tailscaleKeys;
  "tailscale-game-preauth-key.age".publicKeys = tailscaleKeys;
  "tailscale-reverse-proxy-preauth-key.age".publicKeys = tailscaleKeys;
  "tailscale-general-preauth-key.age".publicKeys = tailscaleKeys;
  "tailscale-trust-preauth-key.age".publicKeys = tailscaleKeys;
  ## Headscale config keys
  "headscale-db-password.age".publicKeys = tailscaleKeys;
  "headscale-private-key.age".publicKeys = tailscaleKeys;
  "headscale-tls-crt.age".publicKeys = tailscaleKeys;
  "headscale-tls-key.age".publicKeys = tailscaleKeys;

  # Wireless Secret keys
  "wireless-iot.env.age".publicKeys = wirelessKeys;

  # Secrets SSH keys - in this instance all hard-tokens so 
  # threat modeling would require physical access to fully
  # compromise anyway.
  # Here we use a prefix of $USERNAME- so we can dynamically 
  # generate suitable configs re; identity files and whatnot
  "jay-id-ed25519-sk-type-a-1.age".publicKeys = sshKeys;
  "jay-id-ed25519-sk-type-c-1.age".publicKeys = sshKeys;
  "jay-id-ed25519-sk-type-a-2.age".publicKeys = sshKeys;
  "jay-id-ed25519-sk-type-c-2.age".publicKeys = sshKeys;

  # SSH key used for remote builds
  "builder-id-ed25519.age".publicKeys = sshKeys;
}
