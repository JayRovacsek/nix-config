_: {
  Serilog = {
    MinimumLevel = {
      Default = "Information";
      Override = {
        Microsoft = "Warning";
        System = "Warning";
      };
    };
    WriteTo = [
      {
        Name = "Console";
        Args = {
          outputTemplate = "[{Timestamp:HH:mm:ss}] [{Level:u3}] [{ThreadId}] {SourceContext}= {Message:lj}{NewLine}{Exception}";
        };
      }
      {
        Name = "Async";
        Args = {
          configure = [
            {
              Name = "File";
              Args = {
                path = "%JELLYFIN_LOG_DIR%//log_.log";
                rollingInterval = "Day";
                retainedFileCountLimit = 3;
                rollOnFileSizeLimit = true;
                fileSizeLimitBytes = 100000000;
                outputTemplate = "[{Timestamp:yyyy-MM-dd HH:mm:ss.fff zzz}] [{Level:u3}] [{ThreadId}] {SourceContext}= {Message}{NewLine}{Exception}";
              };
            }
          ];
        };
      }
    ];
    Enrich = [
      "FromLogContext"
      "WithThreadId"
    ];
  };
}
