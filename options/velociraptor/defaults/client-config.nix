{ cfg, ... }:
# Hey there! If you're keen to tell me secrets below
# shouldn't be in source code, please don't :)
# The below values are not utilised and only intended to showcase 
# what a default configuration may look like.
# Have an awesome day!
let
  version = {
    name = cfg.package.pname;
    inherit (cfg.package) version;
    commit = "deadbeef";
    build_time = "";
    install_time = 0;
    ci_build_url = "";
    compiler = "go1.22.2";
  };
in {
  inherit version;
  Client = {
    ca_certificate = ''
      -----BEGIN CERTIFICATE-----
      MIIDTDCCAjSgAwIBAgIRANBgWaWEkCBP3mse8XAGLZMwDQYJKoZIhvcNAQELBQAw
      GjEYMBYGA1UEChMPVmVsb2NpcmFwdG9yIENBMB4XDTI0MDYxNDIyMDU0M1oXDTM0
      MDYxMjIyMDU0M1owGjEYMBYGA1UEChMPVmVsb2NpcmFwdG9yIENBMIIBIjANBgkq
      hkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAuB4WkqIth5109CPGBgZMIWOhfW1Db5oA
      VZtyXrPB26jdWYCBciox7oZun5d3tjdWPcQ6naCWsceWDnas3N6oMSnm/5JYl7ic
      r4NPKm6wEzJgn00zXVvXg/wNOdmxvDKGCAyC/lvp2Z+vB9Rp2NQt7ZLUSoUk+fpW
      XViOMcCCDm3ri0HEswyq3a4jtOa5Hhrou877oRvsuYT5txk3MnCfIjaVES4/7qs7
      RRyDwiyzJ3+dhYlBWRDO6IbkZiHnPOWawYc+BsDdSl7W3fVBeHmFY4Wwwk1SnKY3
      A/v5aT1OVYJkH8+saGhXGaHrzknOGN0J8McCBPXzpesSFiy/8EaaqQIDAQABo4GM
      MIGJMA4GA1UdDwEB/wQEAwICpDAdBgNVHSUEFjAUBggrBgEFBQcDAQYIKwYBBQUH
      AwIwDwYDVR0TAQH/BAUwAwEB/zAdBgNVHQ4EFgQUM5ppZPt3vZHfDQ/blLGqSQ9I
      7+MwKAYDVR0RBCEwH4IdVmVsb2NpcmFwdG9yX2NhLnZlbG9jaWRleC5jb20wDQYJ
      KoZIhvcNAQELBQADggEBAEZn0u/Xvx0nFz9kQubuVMxNzC34W6JEO0X5tP6GNmhg
      NGg+yVYrT2jfcMVB+IVCbUllEQdVCFDt/LVKzYry+YC1os/NHfTM/ULyP0J2J4Jm
      PPsotJPaeHsiVLq0Qa34psBbaIQWr5MR+4Ag15L1KOa+4+xw80B3lSN50o5abfID
      jng2I2X01orjGf3feZOvSF8NZcE70C+xuDqNLPL//Maj6XhKpZ5jKuyCuDWYbMIF
      mnpNRCwzemyjFEWZOb997HdE5oWd1m0ZYDJIyPQXBNTTC2zofDH4DASKUy/sniDm
      pG4CaD6iCX06pLFoc1ERmdIpHVTv+7ETGoCPWkVu8js=
      -----END CERTIFICATE-----
    '';
    nonce = "aiEyJXqc11s=";

    level2_writeback_suffix = ".bak";
    max_poll = 60;
    max_upload_size = 5242880;
    nanny_max_connection_delay = 600;
    server_urls = [ "wss://localhost:8000/" ];
    tempdir_windows = "$ProgramFilesVelociraptorTools";
    use_self_signed_ssl = true;
    writeback_darwin = "/etc/velociraptor.writeback.yaml";
    writeback_linux = "/etc/velociraptor.writeback.yaml";
    writeback_windows = "HKLMSOFTWAREVelocidexVelociraptor";

    local_buffer = {
      memory_size = 52428800;
      disk_size = 1073741824;
      filename_linux = "/var/tmp/Velociraptor_Buffer.bin";
      filename_windows = "$TEMP/Velociraptor_Buffer.bin";
      filename_darwin = "/var/tmp/Velociraptor_Buffer.bin";
    };

    darwin_installer = {
      service_name = "com.velocidex.velociraptor";
      install_path = "/usr/local/sbin/velociraptor";
    };

    windows_installer = {
      service_name = "Velociraptor";
      install_path = "$ProgramFilesVelociraptorVelociraptor.exe";
      service_description = "Velociraptor service";
    };

    inherit version;
  };
}
