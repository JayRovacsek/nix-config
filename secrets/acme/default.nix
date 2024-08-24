let
  primary-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBC9G7Hn8ahBlhZr42QUxDRXQCD/TZ8orl7goPba9ONW";
  secondary-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBY2bcMWuDHB22hNgNnIg2WtvPgKpSWR60CqDo3a32z9";
  keys = [
    primary-key
    secondary-key
  ];
in
{
  "environment-file.age".publicKeys = keys;
}
