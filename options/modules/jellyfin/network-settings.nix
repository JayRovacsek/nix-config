{ cfg, ... }:
{
  name = "NetworkConfiguration";
  props = ''xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"'';

  value = [
    {
      name = "RequireHttps";
      value = false;
    }
    { name = "CertificatePath"; }
    { name = "CertificatePassword"; }
    { name = "BaseUrl"; }
    {
      name = "PublicHttpsPort";
      value = cfg.ports.https;
    }
    {
      name = "HttpServerPortNumber";
      value = cfg.ports.http;
    }
    {
      name = "HttpsPortNumber";
      value = cfg.ports.https;
    }
    {
      name = "EnableHttps";
      value = true;
    }
    {
      name = "PublicPort";
      value = cfg.ports.http;
    }
    {
      name = "UPnPCreateHttpPortMap";
      value = false;
    }
    { name = "UDPPortRange"; }
    {
      name = "EnableIPV6";
      value = false;
    }
    {
      name = "EnableIPV6";
      value = true;
    }
    {
      name = "EnableSSDPTracing";
      value = false;
    }
    { name = "SSDPTracingFilter"; }
    {
      name = "UDPSendCount";
      value = 2;
    }
    {
      name = "UDPSendCount";
      value = 100;
    }
    {
      name = "IgnoreVirtualInterfaces";
      value = true;
    }
    {
      name = "VirtualInterfaceNames";
      value = "vEthernet*";
    }
    {
      name = "GatewayMonitorPeriod";
      value = 60;
    }
    {
      name = "TrustAllIP6Interfaces";
      value = false;
    }
    { name = "HDHomerunPortRange"; }
    { name = "PublishedServerUriBySubnet"; }
    {
      name = "IgnoreVirtualInterfaces";
      value = false;
    }
    {
      name = "AutoDiscoveryTracing";
      value = false;
    }
    {
      name = "AutoDiscovery";
      value = false;
    }
    { name = "RemoteIPFilter"; }
    {
      name = "IsRemoteIPFilterBlacklist";
      value = true;
    }
    {
      name = "EnableUPnP";
      value = false;
    }
    {
      name = "EnableRemoteAccess";
      value = true;
    }
    {
      name = "LocalNetworkSubnets";
      value = [
        {
          name = "string";
          value = "192.168.1.0/24";
        }
        {
          name = "string";
          value = "192.168.2.0/24";
        }
        {
          name = "string";
          value = "192.168.3.0/24";
        }
        {
          name = "string";
          value = "192.168.5.0/24";
        }
        {
          name = "string";
          value = "192.168.7.0/24";
        }
        {
          name = "string";
          value = "192.168.8.0/24";
        }
      ];
    }
    { name = "LocalNetworkAddresses"; }
    { name = "KnownProxies"; }
    {
      name = "EnablePublishedServerUriByRequest";
      value = false;
    }
  ];
}
