_: {
  services.grafana = {
    enable = true;

    settings = {
      alerting.enabled = false;
      analytics.reporting_enabled = false;
      "auth.anonymous".enabled = false;
      panels.disable_sanitize_html = true;
      security = {
        # TODO: change before deploy
        admin_user = "admin";
        admin_password = "test";
      };
      unified_alerting.enabled = true;
      server = {
        domain = "grafana.rovacsek.com";
        # root_url = "https://${name}.${domain}/";
        enable_gzip = true;
        # TODO: change prior to deploy
        enforce_domain = false;
        # TODO: change prior to deploy
        protocol = "http";
        http_port = 3002;
      };
      users.auto_assign_org_role = "Editor";
    };
  };
}
