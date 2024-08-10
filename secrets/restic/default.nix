let
  primary-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAb/50/CQbxIvQcNkryk4Oi6lpaNy6n+clkq3i9L3PA4 ";
  secondary-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBWrOarQspazN9SZrWCz2+mETjf+QX3ZYHu5Nkj9ydvC";
  keys = [
    primary-key
    secondary-key
  ];
in
{
  "databases-local-disk-backup-env.age".publicKeys = keys;
  "databases-backblaze-backup-env.age".publicKeys = keys;

  "logs-backblaze-backup-env.age".publicKeys = keys;
  "logs-local-disk-backup-env.age".publicKeys = keys;
  "logs-password.age".publicKeys = keys;

  "nextcloud-backblaze-backup-env.age".publicKeys = keys;
  "nextcloud-local-disk-backup-env.age".publicKeys = keys;
  "nextcloud-password.age".publicKeys = keys;

  "personal-video-local-disk-backup-env.age".publicKeys = keys;
  "personal-video-backblaze-backup-env.age".publicKeys = keys;

  "storage-local-disk-backup-env.age".publicKeys = keys;
  "storage-backblaze-backup-env.age".publicKeys = keys;

  "wasabi-backup-env.age".publicKeys = keys;
}
