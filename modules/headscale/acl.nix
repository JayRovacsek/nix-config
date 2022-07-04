{ config, pkgs, ... }:
let
  aclConfig = {
    acls = [{
      action = "accept";
      src = [ "*" ];
      dst = [ "*:*" ];
    }];
    ssh = [{
      action = "check";
      src = [ "autogroup:members" ];
      dst = [ "autogroup:self" ];
      users = [ "autogroup:nonroot" "root" ];
    }];
  };
in {
  environment.etc."headscale/acls.json" = {
    user = config.services.headscale.user;
    group = config.services.headscale.group;
    text = builtins.toJSON aclConfig;
  };
}
