let
  primaryTerraformKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII2ZE7cAT/BQaKxGXjS/GivkT1Le35hOv+s12AeXSp4d";
  secondaryTerraformKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFE/0UINSHALBMSe23UyYum0DOz5yddFdekW8IJW9qqT";
  terraformKeys = [
    primaryTerraformKey
    secondaryTerraformKey
  ];
in
{
  "terraform-api-key.age".publicKeys = terraformKeys;
}
