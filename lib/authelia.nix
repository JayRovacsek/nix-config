_:
let
  generate-access-rules = domains: service-name: {
    production.settings.access_control.rules = builtins.map (domain: {
      domain = "${service-name}.${domain}";
      policy = "two_factor";
      subject = "group:${service-name}";
    }) domains;

    test.settings.access_control.rules = builtins.map (domain: {
      domain = "${service-name}.test.${domain}";
      policy = "one_factor";
      subject = "group:${service-name}";
    }) domains;
  };
in { inherit generate-access-rules; }
