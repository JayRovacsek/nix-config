{ cfg, ... }:
{
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
      name = "ApiKey";
      # This value is overridden with use of the api-key-file
      # attribute. Otherwise you're likely to have a bad time.
      value = "deadb33fdeadb33fdeadb33fdeadb33f";
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
