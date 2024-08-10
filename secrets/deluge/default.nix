let
  primary-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMWO7dR1Y6vitlmJpLe/j3ibVK82HMU6jKdJsow09jCu";
  secondary-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM1KCfn7rFuMGybOnJ6AwgiW/mRzSf7Ar7cbpErVcRyO";
  keys = [
    primary-key
    secondary-key
  ];
in
{
  "auth-file.age".publicKeys = keys;
}
