_: {
  services.tor = {
    enable = true;
    settings = {
      ClientUseIPv4 = true;
      ClientUseIPv6 = false;
      SocksPort = [ 9090 ];
    };
  };
}
