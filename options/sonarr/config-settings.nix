{ cfg, ... }: {
  name = "Config";
  value = [
    {
      name = "LogLevel";
      value = cfg.logLevel;
    }
    {
      name = "EnableSsl";
      value = cfg.enableSsl;
    }
    {
      name = "Port";
      value = cfg.ports.http;
    }
    {
      name = "SslPort";
      value = cfg.ports.https;
    }
    {
      name = "BindAddress";
      value = "*";
    }
    {
      name = "AuthenticationMethod";
      value = cfg.authenticationMethod;
    }
    {
      name = "UpdateMechanism";
      value = "BuiltIn";
    }
    {
      name = "Branch";
      value = "main";
    }
    {
      name = "LaunchBrowser";
      value = true;
    }
    {
      name = "SslCertHash";
      value = "";
    }
    {
      name = "UrlBase";
      value = "";
    }
    {
      name = "SyslogPort";
      value = cfg.ports.syslog;
    }
    {
      name = "AnalyticsEnabled";
      value = false;
    }
  ];
}
