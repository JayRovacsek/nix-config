{ interface ? "eth0", ... }: {
  networking.vlans.dns = {
    inherit interface;
    id = 6;
  };
}
