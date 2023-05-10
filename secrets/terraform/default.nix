let
  primaryTerraformKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFufEoK+LGcpNy7PnCih/LwwrjANruawcCzeh2INnZ0A";
  secondaryTerraformKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPSITKapgYMXOYu/OeVznsQlRkrl6gScyuR9PA2z+hA7";
  terraformKeys = [ primaryTerraformKey secondaryTerraformKey ];
in { "terraform-api-key.age".publicKeys = terraformKeys; }
