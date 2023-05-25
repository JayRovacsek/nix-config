_:
let

  # So this is a fair hack to avoid evaluation time per host in this
  # flake. But we will likely be able to address failing points with this in
  # the future by creating a new app to accompany distributed builds 
  # that would generate ahead of time better FQDN names when tailscale is 
  # also in the mix
  #
  # TODO: be less hacky
  system-configs =
    builtins.fromJSON (builtins.readFile ../static/build-machines.json);

  generate-ssh-config = user: identity-files:
    builtins.map (cfg: ''
      Host ${cfg.hostName}
        AddKeysToAgent yes
        ConnectTimeout 3
        ForwardAgent yes
        HostName ${cfg.hostName}
        IdentitiesOnly yes
        User ${user}
        ${identity-files}
    '') system-configs;

in { inherit generate-ssh-config; }
