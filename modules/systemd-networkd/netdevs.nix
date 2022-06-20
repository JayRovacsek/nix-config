{
  # VLANS
  "10-vlan-dns" = {
    netdevConfig = {
      Kind = "vlan";
      Name = "vlan-dns";
    };
    vlanConfig.Id = 6;
  };

  # Bridges
  "20-bridge-dns" = {
    netdevConfig = {
      Name = "br-dns";
      Kind = "bridge";
    };
  };
}
