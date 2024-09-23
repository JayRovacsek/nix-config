let
  keys = import ../../common/keys.nix { };

  primaryWirelessKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBfry8LxgYjnHJjefyvfi/N17Zkem9Zgzh0WvopLYEM2";
  secondaryWirelessKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBLQQwX0Q7f6E8ZkIOmTwuE/8dGZinWjBiCFVUwP3V9S";
  wirelessKeys = [
    primaryWirelessKey
    secondaryWirelessKey
  ];

  gastly-keys = with keys; [
    gastly-primary-key
    gastly-secondary-key
  ];

  wigglytuff-keys = with keys; [
    wigglytuff-primary-key
    wigglytuff-secondary-key
  ];
in
{
  # Wireless Secret keys
  "wireless-iot.env.age".publicKeys = wirelessKeys ++ wigglytuff-keys;
  "wireless-home.env.age".publicKeys = wirelessKeys ++ gastly-keys;
  "wireless-pixel-hotspot.env.age".publicKeys = wirelessKeys ++ gastly-keys;
  "wireless-samsung-hotspot.env.age".publicKeys = wirelessKeys ++ gastly-keys;
  "wireless-mbd.env.age".publicKeys = wirelessKeys;
}
