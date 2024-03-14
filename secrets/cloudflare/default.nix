let
  primaryCloudflareKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAo9loEe3GoXXl/lCN8f9zUtrHYaGIalBmPC8viw/JsU";
  secondaryCloudflareKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMehTWF7MiwtmRAyYc/VJlP3KoLTxb6+slGgVssUdzcP";
  keys = [ primaryCloudflareKey secondaryCloudflareKey ];
in { "dynamic-dns-api-key.age".publicKeys = keys; }
