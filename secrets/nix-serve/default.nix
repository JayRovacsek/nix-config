let
  primary-key =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOvNXUrfjQHhIiJBsE90t9Lqh93ppeqiPccu+43uunXL";
  secondary-key =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHoZFPweXfKRafs74qVmEhdCnTt3Wb7GlLBotyX7DbMY";
  keys = [ primary-key secondary-key ];
in { "cache-priv-key.pem.age".publicKeys = keys; }
