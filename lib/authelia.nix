_:
let
  generate-prod-access-rule = domain: service-name: {
    domain = "${service-name}.${domain}";
    policy = "two_factor";
    subject = "group:${service-name}";
  };

  generate-prod-access-rules = domains: service-name:
    builtins.map (domain: generate-prod-access-rule domain service-name)
    domains;

  generate-test-access-rule = domain: service-name: {
    domain = "${service-name}.test.${domain}";
    policy = "one_factor";
    subject = "group:${service-name}";
  };

  generate-test-access-rules = domains: service-name:
    builtins.map (domain: generate-test-access-rule domain service-name)
    domains;

  generate-access-rules = domains: service-name: {
    production.settings.access_control.rules =
      builtins.map (domain: generate-prod-access-rule domain service-name)
      domains;

    test.settings.access_control.rules =
      builtins.map (domain: generate-test-access-rule domain service-name)
      domains;
  };
in {
  inherit generate-access-rules generate-prod-access-rule
    generate-prod-access-rules generate-test-access-rule
    generate-test-access-rules;
}
