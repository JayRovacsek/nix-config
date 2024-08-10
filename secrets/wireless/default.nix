let
  primaryWirelessKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBfry8LxgYjnHJjefyvfi/N17Zkem9Zgzh0WvopLYEM2";
  secondaryWirelessKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBLQQwX0Q7f6E8ZkIOmTwuE/8dGZinWjBiCFVUwP3V9S";
  wirelessKeys = [
    primaryWirelessKey
    secondaryWirelessKey
  ];
in
{
  # Wireless Secret keys
  "wireless-iot.env.age".publicKeys = wirelessKeys;
  "wireless-home.env.age".publicKeys = wirelessKeys;
  "wireless-pixel-hotspot.env.age".publicKeys = wirelessKeys;
  "wireless-samsung-hotspot.env.age".publicKeys = wirelessKeys;
  "wireless-mbd.env.age".publicKeys = wirelessKeys;
}
