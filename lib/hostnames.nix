{ self }:
let
  inherit (self.common.headscale) base-domain;
  inherit (self.lib.tailscale) lookup-tailnet;
  inherit (self.inputs.nixpkgs) lib;

  generate-simple-address = cfg: cfg.networking.hostName;

  generate-local-address = cfg:
    let
      inherit (cfg.networking) localDomain;
      has-value = localDomain != "";
    in "${cfg.networking.hostName}${
      lib.optionalString has-value ".${localDomain}"
    }";

  generate-tailscale-address = cfg:
    let
      inherit (cfg.networking) hostName;
      tailnet = lookup-tailnet hostName;
    in "${hostName}.${tailnet}.${base-domain}";

  generate-addresses = cfg:
    let
      local-address = generate-local-address cfg;
      simple-address = generate-simple-address cfg;
      tailscale-address = generate-tailscale-address cfg;
    in { inherit local-address simple-address tailscale-address; };

in {
  inherit generate-addresses generate-local-address generate-simple-address
    generate-tailscale-address;
}
