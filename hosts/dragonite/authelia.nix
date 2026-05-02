{
  config,
  lib,
  self,
  ...
}:
let
  inherit (self.lib.authelia)
    generate-prod-access-rules
    generate-test-access-rules
    ;

  inherit (self.common.config) services;

  authelia-scoped-services = lib.filterAttrs (
    _: v: if builtins.hasAttr "authelia" v then v.authelia else false
  ) services;

  proxied-services = builtins.attrNames authelia-scoped-services;

in
{
  services = {
    authelia.instances =
      builtins.foldl'
        (
          acc: service-name:
          let
            prod-access-rules = generate-prod-access-rules config.services.nginx.domains service-name;
            test-access-rules = generate-test-access-rules config.services.nginx.domains service-name;
          in
          {
            production.settings.access_control.rules =
              acc.production.settings.access_control.rules ++ prod-access-rules;
            test.settings.access_control.rules =
              acc.production.settings.access_control.rules ++ test-access-rules;
          }
        )
        {
          production.settings.access_control.rules = [ ];
          test.settings.access_control.rules = [ ];
        }
        proxied-services;

    nginx.domains = [ "rovacsek.com" ];
  };
}
