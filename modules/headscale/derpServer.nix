{ config, pkgs, lib, ... }:
let
  homeNodes = [{
    Name = "1";
    RegionID = "99";
    HostName = "stun.headscale.rovacsek.com";
  }];

  derpServerConfig = {
    Regions = {
      "99" = {
        RegionID = 99;
        RegionCode = "home";
        RegionName = "home";
        Nodes = homeNodes;
      };
    };
  };
in {
  environment.etc."headscale/derp-server.json" = {
    inherit (config.services.headscale) user group;
    text = builtins.toJSON derpServerConfig;
  };
}
