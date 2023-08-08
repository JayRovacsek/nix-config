{ self, ... }:
let
  inherit (self.common.terraform.globals) cloudflare;
  inherit (self.lib.terraform) tfvar tfdata;
  name = "cloudflare";
in rec {
  variable = {
    CLOUDFLARE_API_TOKEN_CREATE = {
      type = "string";
      description = "Cloudflare token that can create other tokens";
      nullable = false;
      sensitive = true;
    };
  };

  terraform = {
    cloud = {
      organization = "TSvY5rCj9RAYyz4z2W7JZ5VwY2ec9EDg";
      workspaces = { inherit name; };
    };
    required_providers = {
      cloudflare = {
        source = "cloudflare/cloudflare";
        version = "4.9.0";
      };
    };
  };

  data = {
    cloudflare_api_token_permission_groups.all = { };
    cloudflare_zone."rovacsek.com".name = "rovacsek.com";
  };

  provider.cloudflare.api_token = tfvar "CLOUDFLARE_API_TOKEN_CREATE";

  resource = {
    cloudflare_zone = {
      rovacsek = {
        account_id = "2f9533403f3018832e20b68b23b81277";
        zone = "rovacsek.com";
      };
    };

    # DNSSEC configuration
    cloudflare_zone_dnssec.dns_sec = {
      zone_id = tfdata ''cloudflare_zone."rovacsek.com"'';
    };

    # SPF records
    cloudflare_record.spf_record = {
      zone_id = tfdata ''cloudflare_zone."rovacsek.com"'';
      name = "example.com";
      type = "TXT";
      value = "v=spf1 include:_spf.example.com ~all";
      ttl = 1800;
    };

    # DMARC record
    cloudflare_record.dmarc_record = {
      zone_id = tfdata ''cloudflare_zone."rovacsek.com"'';
      name = "_dmarc.example.com";
      type = "TXT";
      value =
        "v=DMARC1; p=none; sp=none; rua=mailto:dmarc@jay.rovacsek.com; ruf=mailto:dmarc@jay.rovacsek.com; fo=1; adkim=r; aspf=r";
      ttl = 1800;
    };

    # DKIM records
    cloudflare_record = {
      "fm1._domainkey" = {
        name = "fm1._domainkey";
        proxied = true;
        type = "CNAME";
        value = "fm1.rovacsek.com.dkim.fmhosted.com";
        zone_id = tfdata ''cloudflare_zone."rovacsek.com"'';
      };

      "fm2._domainkey" = {
        name = "fm2._domainkey";
        proxied = true;
        type = "CNAME";
        value = "fm2.rovacsek.com.dkim.fmhosted.com";
        zone_id = tfdata ''cloudflare_zone."rovacsek.com"'';
      };

      "fm3._domainkey" = {
        name = "fm3._domainkey";
        proxied = true;
        type = "CNAME";
        value = "fm3.rovacsek.com.dkim.fmhosted.com";
        zone_id = tfdata ''cloudflare_zone."rovacsek.com"'';
      };
    };
  };
}
