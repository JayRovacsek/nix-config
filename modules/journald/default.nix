_: {
  services.journald = {
    extraConfig = ''
      MaxRetentionSec=6hour
      SystemMaxUse=256M
    '';
    storage = "volatile";
  };
}
