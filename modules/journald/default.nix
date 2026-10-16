_: {
  services.journald = {
    settings.Journal = {
      MaxRetentionSec = "6hour";
      SystemMaxUse = "256M";
    };
    storage = "volatile";
  };
}
