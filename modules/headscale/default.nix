{
  services.headscale = {
    settings = { };
    enable = true;
    address = "0.0.0.0";
    serverUrl = "https://headscale.rovacsek.com:443";
    dns = {
      nameservers = [ "1.1.1.1" ];
      domains = [ "rovacsek.com.internal" ];
      baseDomain = "rovacsek.com";
    };
    ## TODO: Address the below to use my own options.
    # see also: https://github.com/kradalby/dotfiles/blob/bfeb24bf2593103d8e65523863c20daf649ca656/machines/headscale.oracldn/headscale.nix#L45
    # derp = {
    #   urls = [];
    #   paths = [];
    # updateFrequency
    # autoUpdate
    # };
    # Define ACLS as json file in path - this would be far better nixified but all in time.
    aclPolicyFile = "";
    # I can see the below being problematic while still using SWAG.
    # Will need to dig into changing this once I can extract SWAG into nixified modules.
    tls.letsencrypt = {
      certFile = "";
      keyFile = ""; # Both require a path on host to existing valid certs
    };
    # Looks like the below will require uplift to authelia 
    # see: https://www.authelia.com/docs/configuration/identity-providers/oidc.html#openid-connect
    openIdConnect = {
      issuer = "";
      domainMap = { };
      clientId = "headscale";
      clientSecretFile = config.age.secrets.headscale-oidc-secret.path;
    };
    # I don't think the below is really required just yet, a default of 
    # 30 mins seems just fine
    # ephemeralNodeInactivityTimeout = "5m";
  };
}
