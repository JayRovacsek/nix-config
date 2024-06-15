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
  Client = import ./client-config.nix { inherit cfg; };
in {
  inherit version;
  inherit (Client) Client;

  API = {
    hostname = "localhost";
    bind_address = "127.0.0.1";
    bind_port = 8001;
    bind_scheme = "tcp";
  };

  api_config = { };

  CA = {
    private_key = ''
      -----BEGIN RSA PRIVATE KEY-----
      MIIEpQIBAAKCAQEAuB4WkqIth5109CPGBgZMIWOhfW1Db5oAVZtyXrPB26jdWYCB
      ciox7oZun5d3tjdWPcQ6naCWsceWDnas3N6oMSnm/5JYl7icr4NPKm6wEzJgn00z
      XVvXg/wNOdmxvDKGCAyC/lvp2Z+vB9Rp2NQt7ZLUSoUk+fpWXViOMcCCDm3ri0HE
      swyq3a4jtOa5Hhrou877oRvsuYT5txk3MnCfIjaVES4/7qs7RRyDwiyzJ3+dhYlB
      WRDO6IbkZiHnPOWawYc+BsDdSl7W3fVBeHmFY4Wwwk1SnKY3A/v5aT1OVYJkH8+s
      aGhXGaHrzknOGN0J8McCBPXzpesSFiy/8EaaqQIDAQABAoIBAQCZHyzWtln3N1RU
      1ouR5xrZiep8TaqP3hv5FlZ/vC+1ZzLvhJgjQkRUgyjtQSMmP89RfyjgfvXU1JBP
      ZxNMfUCT4q1iT2uugrKMpT/pojR9QqBo2+Oj+QW7lpvJSOswATTG7ODkebx6aPtA
      H8AHvC6WLk6vyxt9alz5NPTNG7UOGaNvlzZh79ZZjQRj7ILDXK8VDipD38iwdqsI
      RuLaD43jYEt4P4ShyJjmKY1KuopmJNyhFNzPeyuPhA9+1GKTm30IuVR6q+1+YTm3
      VeY8wygV6acIhfDc/Rfzvb7d1XCZ/nSeUdVENyiNxiCZZOX23bzayQfcOPbBmCE4
      6Pu6tvghAoGBANuYPeoxJAdsUqvt1tbGRFlJmWf+2ErXvrucMlhpZvKUyzZHLyI5
      CcclYrVsSF56EBj0eMA0WiQACZBmMC7N7uGiYFQTjx8cvm9uUvqjNsrQ2UsXkMD1
      dpPvU8ZdfjO5UmxUj0vWt4TJHzPwFsriIwKkKTrd/0elOYGw5FyrKWSvAoGBANak
      K3ekQseyRX780/U027JYaHTs4QN2sCHHQBjCacqsikzTVrfzHePg43XwQHDuSz6m
      GX6uPSwxH87bcMFzmDfrFJcdiigXidIlpmvepd32umOz605XkuM3ubwafktFzm3e
      1d9ILDvXEt1Ljg9yFADyVT7N+0eW9lA/9dAu5PwnAoGAID9DGFkPCWgG2+iZXADR
      mKsONA9gg90azUIqwoD39TeUf+wEJ+poXS5ISIwWNImIQ6Hi+Za2hgLbZLEc8kKb
      idbmfnJA2jjGXma9GMFPEomI31Yek7d4KlFC5CZmmgHk8LOaN3DYkk9WnbHsJu7+
      ZSzmQRbIniTNRRZM8q7P7VECgYEAtOaqp+xuSCaNAgkOj1SccYSnjRx0TNoEeoOX
      FwcL6MBg030vUlv57iyFKMpzVXrROhz90dICRrOkblBuiOzm9wIPWYmQ/ldQVihb
      SgDd5ORklVF3WZDfgNdfmBTwKnrMD7fGo6gNd+W9xXs/YO8xwtZ7WDJ8vQqT0HEH
      uQ08+vMCgYEAuwmMXaijyFjIrtv0U2oJPhFZH9smvs1oTqTgihMsd4GTPQHtZtCi
      03rGnxvgHw8fx158cEywcNLq1tJHAUMQldbvVVs8jB2VK+rXSlwjkO7kBfSLJToT
      NmL3bl12i/DsfCy9jceGpY2J39kMFBqoM1MDJvI7NPRdzZuZsTWg78c=
      -----END RSA PRIVATE KEY-----
    '';
  };

  Datastore = {
    implementation = "FileBaseDataStore";
    location = "/var/lib/velociraptor";
    filestore_directory = "/var/lib/velociraptor";
  };

  defaults = {
    hunt_expiry_hours = 168;
    notebook_cell_timeout_min = 10;
  };

  Frontend = {
    hostname = "localhost";
    bind_address = "0.0.0.0";
    bind_port = 8000;
    certificate = ''
      -----BEGIN CERTIFICATE-----
      MIIDWDCCAkCgAwIBAgIRAKDCntu2bQg+OR+oKcrmGb0wDQYJKoZIhvcNAQELBQAw
      GjEYMBYGA1UEChMPVmVsb2NpcmFwdG9yIENBMB4XDTI0MDYxNDIyMDU0NVoXDTI1
      MDYxNDIyMDU0NVowNDEVMBMGA1UEChMMVmVsb2NpcmFwdG9yMRswGQYDVQQDExJW
      ZWxvY2lyYXB0b3JTZXJ2ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
      AQCZusLvFioYCjCkLfOxKtNmTiF4GAmmwRTJGOvdUA5UpqemJVbq2o0aLvCg4MZl
      4LphjWWWkfa/ckYRy2mQ2hAUPBI/i9omrLYV/+28T8DZIPMv4cim0gkJ+VZKCTU1
      OOoYWoniyzNTf9bMidfUxZDhaPCyKnEIxP/9Tw+aLYFnothp7jCSfPZIH1Z/r5rV
      62dOF0h7KDxaOCKMWrt8dDB25hgNzHXbbplx0gtA+dhsDq7+uVgjLiZeU3yyR7SX
      cZiDSI/gmODwRLUN4pgUKtIbVtTl7ggslLsGT5Dh4mFMe+49ht1cMPQCTriPjEdd
      HU+8wW0wdb+HDX+n7shQzdKHAgMBAAGjfzB9MA4GA1UdDwEB/wQEAwIFoDAdBgNV
      HSUEFjAUBggrBgEFBQcDAQYIKwYBBQUHAwIwDAYDVR0TAQH/BAIwADAfBgNVHSME
      GDAWgBQzmmlk+3e9kd8ND9uUsapJD0jv4zAdBgNVHREEFjAUghJWZWxvY2lyYXB0
      b3JTZXJ2ZXIwDQYJKoZIhvcNAQELBQADggEBAJevFgNTLJpw5qqdL9hCAq1yc1T4
      UGFEnt6Xo6gfS5Z6bR4kfpUglqGRYDq+eQOrcP6rnLZp6aiR3SRsbVSINoGSbDdI
      P8aBr5KYhIfx5eKhfMgcziZXxMbgd2iXUe0SLvBG0sPCpQbjbJJaXrs2PAs0QgVh
      TVxfCsxqijQnuVmmhT78ZF+y4O7R8E0QX618f7qvYgTvCo6j6pTYfn1rMhcnGQyL
      QTv/J1rGI1iYcrAGhUmk0LogDQh8YW0dcmzvoMQD0UNhNp9v599AXTYjTY00R1XF
      o0fybRoYgrlyjdidzNbKiPZfwBaBWBwPjD89nKfjyvrTXqnczWYtqQv+0sI=
      -----END CERTIFICATE-----
    '';
    private_key = ''
      -----BEGIN RSA PRIVATE KEY-----
      MIIEogIBAAKCAQEAmbrC7xYqGAowpC3zsSrTZk4heBgJpsEUyRjr3VAOVKanpiVW
      6tqNGi7woODGZeC6YY1llpH2v3JGEctpkNoQFDwSP4vaJqy2Ff/tvE/A2SDzL+HI
      ptIJCflWSgk1NTjqGFqJ4sszU3/WzInX1MWQ4WjwsipxCMT//U8Pmi2BZ6LYae4w
      knz2SB9Wf6+a1etnThdIeyg8WjgijFq7fHQwduYYDcx1226ZcdILQPnYbA6u/rlY
      Iy4mXlN8ske0l3GYg0iP4Jjg8ES1DeKYFCrSG1bU5e4ILJS7Bk+Q4eJhTHvuPYbd
      XDD0Ak64j4xHXR1PvMFtMHW/hw1/p+7IUM3ShwIDAQABAoIBAF2upJCSz0ArJY1H
      u5Qh5wYXYuoOrAME8yfBmisaWEFZ9hyX8KnaWda0+Erx77WyB6LfSiNB/D6a4vyB
      G2n8mYPbP7ud/GlJIwWxGy2A5KLtI4XwcBjJMlzzp5QinFw8vNvugMzGzBZ8d2fa
      ML8nTq0vCE9q8ctIUkAJ6BYq2QtQDgFnRNX7wwCxhSTsncEm7smtnWTTCN5JkfrC
      edmYNfDYhgWQQsoU5LR9wJtM4sAwea6CtpTGN5f0T2KYGVDPm8dvYRDhhHJuIc6s
      5XqYtSp5EjEVU/Rc68zbNsMlWyuSqkpaC07IL88bq074SI8A0UBOheN0ibcws8cq
      okm1+BECgYEAyiicLd2/Y/EHEutDKOHjRJVShP2PF1goeD5tfqnZtL8Vd1TbMogU
      s8FddjW9b/EDTptHXEsE505DY7cPOF31pZlEvCPkoyRjR1i6dRn4OTCHhaPNtzap
      hTMFE7fBM4eHY3Q2HZuUTq6n3Pd+1VNgUWhcCopLN4+B8GUf2iN9rssCgYEAwqw0
      SuZFzVWXbOHvIGUMH3y7BseAhQHxaJz/Ky6cfHRuRKmR0RktNwXBgdiGGK7Q5+nv
      nIt0aCmCzRuHr962rEUbA9ky6zlVOpo7BPGRlM6rLc9uD+bZjmY2h+R6figkxXgg
      ApO7ltT+q9X5oQO+GCeNtyUeW4j4mWb/BW4XF7UCgYAid8YZM+O8AI56NU6gG9OK
      EAOf1TOegVN1HP/CRudtn97jF76/4N/WvjNXQlZoTamIr4T9QXU2kut+hum7bJnD
      gFxtz5jeEAg1U/WGncTqy1FwAbvDbzh8E3TcJcp1JLh6xoeriKlCuRi53iDr8mlL
      uAVpbqbgdEFtYXCK2t5E/QKBgFLZHKwfkedQHNCO2sjLmDwyRhodf3mbmRSvc/z5
      qklg96irDc6SS2bWQUM0VeVdSLTaH0pdIx5NREhsBfP38YAhLN0Xa48l6Dq3dpSl
      BhLxXXJyi+GimkX7BAwTVXopNXUAqYbPPo9zeCrDNqiqwhTfiHVAC8pi4YHPjorO
      Dm/dAoGAPiiCvLtZkv7DFA87GbgPBd6jy3KEyCQASIn7gSaiAa48YU4EEcsR9d1P
      Wh4C1OM6zTqcXnDrTQ18yMEglUBOxZl5BvCAZ7/CFisD391HmfkH9bFxhjG/XI9m
      2P6mFpvz7+cjDllUsqLLGhfdeZQQwhHWSoa8F7vny768+1iZhx4=
      -----END RSA PRIVATE KEY-----
    '';
    dyn_dns = { };
    default_client_monitoring_artifacts = [ "Generic.Client.Stats" ];
    GRPC_pool_max_size = 100;
    GRPC_pool_max_wait = 60;
    resources = {
      connections_per_second = 100;
      notifications_per_second = 30;
      max_upload_size = 10485760;
      expected_clients = 30000;
    };
  };

  GUI = {
    bind_address = "127.0.0.1";
    bind_port = 8889;
    gw_certificate = ''
      -----BEGIN CERTIFICATE-----
      MIIDQjCCAiqgAwIBAgIRAMaWNCeI6PJ/1bAAOizovCMwDQYJKoZIhvcNAQELBQAw
      GjEYMBYGA1UEChMPVmVsb2NpcmFwdG9yIENBMB4XDTI0MDYxNDIyMDU0NloXDTI1
      MDYxNDIyMDU0NlowKTEVMBMGA1UEChMMVmVsb2NpcmFwdG9yMRAwDgYDVQQDDAdH
      UlBDX0dXMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA1OlrFTTnja1X
      wLlAzUtNBUqAmnhGBMTQ+V/DgF6RZkZShIr9A5xgO2fXPK6fBsigYOWu85BAFxMo
      jc7trTb+gdTHyBeVbnZg3T6p7p4qksX2MTBNRWP95itLa8rIC2Fnc3h51a3q/YML
      ehXOuxrEfnayboo478vJVG6/q2OFqnnFkq8d6j90D6XJkfF5n2ikx+coU+Kl1rwe
      SfQaJd6Uv09T6R241iHeoNrY3YTmEx4x6ZjEqLUeFbHrRGYz/pCn4rgqQ9Dcp8lg
      nYvPbEi5tgfA5n79wQDVkwhzofDcYdCXX5uqCtMlP4m6aHl1HQTFax5NOxNkElZA
      9cvxsiTA7QIDAQABo3QwcjAOBgNVHQ8BAf8EBAMCBaAwHQYDVR0lBBYwFAYIKwYB
      BQUHAwEGCCsGAQUFBwMCMAwGA1UdEwEB/wQCMAAwHwYDVR0jBBgwFoAUM5ppZPt3
      vZHfDQ/blLGqSQ9I7+MwEgYDVR0RBAswCYIHR1JQQ19HVzANBgkqhkiG9w0BAQsF
      AAOCAQEAN1Vj6kZ9xK28urCx/kEE0hE3V6LX+qM4w1fKSAkt1HQkVyVuxdAyLoPK
      NtnpFrofY3JbKjInr2H07xO7UcfkT1MGb39MVsuWQaQgZcM+TTFDhFc3JDqaL5t6
      hXXNSF3BBhN8Q5Q/x6JYg71tnW9q9gIlHztFccu2DF1KyTuBNlf2fkwTiz2B86ti
      wl3hvQAbsCIZztgwS0dojyDqN0EtXepL5Yra1YVN7dyKpSgktMXWJS6UiTVFBoQi
      tlmPiL4uropiI3hwLdSjZx1WmAMb01d5t6TR1Xbp5NWUgA8ynSOChZcfG9/5FG97
      wBxBwpw144suSb3o6QkVmZpTzfrLTA==
      -----END CERTIFICATE-----
    '';
    gw_private_key = ''
      -----BEGIN RSA PRIVATE KEY-----
      MIIEpQIBAAKCAQEA1OlrFTTnja1XwLlAzUtNBUqAmnhGBMTQ+V/DgF6RZkZShIr9
      A5xgO2fXPK6fBsigYOWu85BAFxMojc7trTb+gdTHyBeVbnZg3T6p7p4qksX2MTBN
      RWP95itLa8rIC2Fnc3h51a3q/YMLehXOuxrEfnayboo478vJVG6/q2OFqnnFkq8d
      6j90D6XJkfF5n2ikx+coU+Kl1rweSfQaJd6Uv09T6R241iHeoNrY3YTmEx4x6ZjE
      qLUeFbHrRGYz/pCn4rgqQ9Dcp8lgnYvPbEi5tgfA5n79wQDVkwhzofDcYdCXX5uq
      CtMlP4m6aHl1HQTFax5NOxNkElZA9cvxsiTA7QIDAQABAoIBAQCv34DNK756kc4D
      LQQSkTk2Payt7Nwp5EqbNDfSOkvxJ/XR9t25tdroN4bcYYKLn/6bDB/Qoj/Oz8yY
      F27NvrfNl27QImsVrEOnfrPwoEaap1wOlc++mjKJhwnuKLvGateB0usRT3DlqPI6
      DvmOJTZbIMGT/im6K6RLUpCRisxHXH3Vq8VMrE6ASGfdFYUuxFDEnZA7+rjfzheg
      m65VGvSLK3ChhEFt9rqoSwY1SKEqIwLcDMzhWEXN45pA9Ujj99aQ8cOuU9hlvoiU
      smk37cKaXEvQ270kzLlJRv1B9MU4qhdo1xrh7YtlECaJAPk55bwCWvVBmh4QlncJ
      benrE9chAoGBAOb4r86S2KEjO4eBjk3ug8dtnkXQS5uOQJJl2mfQbj2fHvC07xGf
      oDP4fW9it7rSn0wrak16bAoh+LjwXHYtHzFq4Wjnnx131I9G/tKyD2U5dzGYjcsX
      CObr8pJoxaEYRFcT3guh+M97FpbLq5YZGgC9vY7DoV/1kQYOL3+04BnzAoGBAOv7
      vn3yWTCbujs6gVlLYyVDq3yD6p95qtZiveL68RuqMf8K7HkzSkeVdeVClzEj856D
      ISUPKg+Sh6NE3sHSf8AyREp+7NNOQ4Nt9ClH55DmzGDwAsLCIikI6gp9+SXPxjUV
      iVG40yjs/MmvAMfZcCtGB4qKlzSF17F3a3oBNpGfAoGAUbCFJY+kVKGMbWmx9fg0
      3XT0tIZuJ09RoTWq4GrEgsDjhYjIwTfuxlLNsnZ8uvPBaYQ1bb+ttIu9V1OTsCxX
      SvgdTygUi6yVHjOi7swRS+DeOklVZQ35lQrAWW367/YQPagGMaEQyfkjzSOtxUGN
      g9OX1oV0bucAat7bh9RmKmcCgYEAr+W7/gEw/gx16kQXukl5I4OnRW7G6gw0jQyY
      4aGPKsHX9nVcApN6oJUFhdf2/of/xX2UrRz6ixT7yXVCXVLcKpTNVoH5YSALLuI8
      hrC0KMwAN5lvVWCDOfcNDLkNh2OyKEtfSezsaKsNWf/6Iv0uoPLYGCppvpqtRfjv
      wcc5t50CgYEA0xWNZFIYfBqgvJu3dXbtLF3T9nOHk2xzG7m8KlyNA6Qlv/X5jasR
      ydAScZhqcQfDpZzel3XuLtfgZ/sYXC64bA63Unjc3VC7B0ETLMcRT/xSekHJhvTb
      BQN8/6G8GZNC6Em/vz25W3hE5dl4KO1ahWLWuy0jccme0S5TID+PYBU=
      -----END RSA PRIVATE KEY-----
    '';
    public_url = "https://localhost:8889/";
    links = [{
      text = "Documentation";
      url = "https://docs.velociraptor.app/";
      icon_url =
        "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSI1MyIgaGVpZ2h0PSI2MyIgdmVyc2lvbj0iMS4xIiB2aWV3Qm94PSIwIDAgNTMgNjMiPjxwYXRoIGQ9Ik0yNyAzYy0zIDItMTMgOC0yMyAxMGw2IDMyYTEwMyAxMDMgMCAwIDAgMTcgMTZsNi01IDExLTExIDYtMzJDMzkgMTEgMzAgNSAyNyAzeiIgZmlsbD0iI2ZmZiIgZmlsbC1ydWxlPSJldmVub2RkIi8+PHBhdGggZD0iTTI2IDBDMjMgMiAxMiA4IDAgMTBjMSA3IDUgMzIgNyAzNWExMTMgMTEzIDAgMCAwIDE5IDE4bDctNiAxMi0xMmMyLTMgNi0yOCA4LTM1QzQwIDggMjkgMiAyNiAwWm0wIDU1LTYtNC04LTktNS0yNnYtMWwyLTFjOC0xIDE2LTYgMTYtNmwxLTEgMSAxczggNSAxNyA2bDEgMXYxcy0zIDIzLTUgMjZsLTggOWMtMiAyLTQgNC02IDR6IiBmaWxsPSIjYWIwMDAwIiBmaWxsLW9wYWNpdHk9IjEiIGZpbGwtcnVsZT0iZXZlbm9kZCIvPjxwYXRoIGQ9Ik0zOSAxOWExMzQ3IDEzNDcgMCAwIDEtMTMgMjZoLTJMMTQgMTloM2wyIDEgMSAxdjFhMjUwIDI1MCAwIDAgMSA2IDE3IDUyODkgNTI4OSAwIDAgMCA5LTIwaDR6IiBmaWxsPSIjMDAwIiBmaWxsLXJ1bGU9ImV2ZW5vZGQiIHN0cm9rZT0iIzAwMCIgc3Ryb2tlLWRhc2hhcnJheT0ibm9uZSIgc3Ryb2tlLWxpbmVjYXA9ImJ1dHQiIHN0cm9rZS1saW5lam9pbj0ibWl0ZXIiIHN0cm9rZS13aWR0aD0iMSIvPjwvc3ZnPg==";
      type = "sidebar";
      new_tab = true;
    }];
    initial_users = [{
      name = "workshop";
      password_hash =
        "30e76d71456160ab0c825e3a6470566a3272564876f2dce255bf55d8c10bbd88";
      password_salt =
        "43904c293470da9d8358294c654e0234214d76c5af86ef64fba640cdda809752";
    }];
    authenticator.type = "Basic";
  };

  Logging = {
    output_directory = "/var/lib/velociraptor/logs";
    separate_logs_per_component = true;
    debug.disabled = true;
    info = {
      rotation_time = 604800;
      max_age = 31536000;
    };
    error = {
      rotation_time = 604800;
      max_age = 31536000;
    };
  };

  Monitoring = {
    bind_address = "127.0.0.1";
    bind_port = 8003;
  };

  obfuscation_nonce = "ZOWW/aKdfvM=";

  server_type = "linux";
}
