{ config, ... }: {
  age = {
    identityPaths = [ "/agenix/id-ed25519-cloudflare-primary" ];

    secrets.cloudflare-api-key = {
      file = ../../secrets/cloudflare/dynamic-dns-api-key.age;
      mode = "0400";
    };
  };

  # Setting this up was, interesting. A few footguns to understand:
  # * zone is not zone as per zone-id in cloudflare
  # * use directive should be roughly as below - I tried a few from other 
  # user's configuration but did not have a great time with them
  # * cloudflare records need to exist prior to you adding them to the
  # below domains list - TODO: finish the cloudflare config terranix
  # likely take some inspiration from this smart cookie:
  # https://github.com/kittywitch/arcnmx-home/blob/f40988631ca8473f5207bc966dae10ef015eb4e0/cfg/personal/ddclient.nix#L39
  services.ddclient = {
    inherit (config.services.nginx) domains;
    enable = true;
    interval = "5min";
    username = "token";
    passwordFile = config.age.secrets.cloudflare-api-key.path;
    protocol = "cloudflare";
    ssl = true;
    use = "web,web=ifconfig.me/ip";
    verbose = true;
    zone = "rovacsek.com";
  };
}
