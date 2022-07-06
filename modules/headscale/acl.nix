{ config, pkgs, lib, ... }:
let
  meta = import ./meta.nix { inherit config pkgs lib; };

  # Below generates group values of "group:$X" for all pre-auth namespaces we've stored
  groups = builtins.foldl' (x: y: x // y) { }
    (builtins.map (x: { "group:${x}" = [ "${x}" ]; }) meta.namespaces);

  # Below generates an allow ACL for inter-namespace communication where the namespace matches the origin
  defaultNamespaceCommunication = builtins.map (x: {
    action = "accept";
    src = [ "${x}" ];
    dst = [ "${x}:*" ];
  }) meta.namespaces;

  allowTrustToAll = [{
    action = "accept";
    src = [ "group:trust" ];
    dst = [ "*:*" ];
  }];

  allowAllToDNS = [{
    action = "accept";
    src = [ "group:*" ];
    dst = [ "group:dns:53,8053" ];
  }];

  aclConfig = {
    inherit groups;
    acls = allowTrustToAll ++ allowAllToDNS ++ defaultNamespaceCommunication;
  };
in {
  environment.etc."headscale/acls.json" = {
    user = config.services.headscale.user;
    group = config.services.headscale.group;
    text = builtins.toJSON aclConfig;
  };
}
