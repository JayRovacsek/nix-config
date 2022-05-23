let
  dnsUserConfig = import ../users/service-accounts/dns.nix;

  # Helper functions for generating correct nix configs
  userFunction = import ../functions/service-user.nix;

  # Actual constructs used to generate useful config
  dnsUser = userFunction { userConfig = dnsUserConfig; };

  readOnlySharedStore = import ./shared/read-only-store.nix;
in {
  users.extraUsers = dnsUser.extraUsers;
  users.extraGroups = dnsUser.extraGroups;

  networking.hostName = "igglybuff";
  microvm.writableStoreOverlay = null;
  microvm = {
    vcpu = 1;
    mem = 1024;
    hypervisor = "qemu";
    shares = [ readOnlySharedStore ];
  };

  imports = [ ../modules/dnsmasq ];
}
