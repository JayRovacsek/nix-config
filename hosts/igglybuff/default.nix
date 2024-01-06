{ config, flake, ... }: {
  inherit flake;

  networking.hostName = "igglybuff";

  microvm = {
    # TODO: determine best approach to passing secrets into microvms.
    # This'll likely end up being a mount of the requisite decryption
    # keys so we can just use age directly as happens in all modules currently.
    # shares = [{
    #   # On the host
    #   source = "/run/agenix";
    #   # In the MicroVM
    #   mountPoint = "/run/agenix";
    #   tag = "id-ed25519-wireless-primary";
    #   proto = "virtiofs";
    # }];
    interfaces = [{
      type = "macvtap";
      id = config.networking.hostName;
      mac = "02:42:c0:a8:06:08";
      macvtap = {
        link = "dns";
        mode = "bridge";
      };
    }];
  };
}
