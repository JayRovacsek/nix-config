{
  config,
  lib,
  self,
  ...
}:
{
  # Extended options for jellyfin
  imports = [ ../../options/modules/jellyfin ];

  # Required to enable nvidia capabilities to jellyfin. Otherwise
  # configuration may seem fine, but never can invoke cuda backed capabilities
  systemd.services.jellyfin = {
    environment.LD_LIBRARY_PATH = "/run/opengl-driver/lib";
    serviceConfig.DeviceAllow = lib.mkForce [
      "/dev/nvidia0 rw"
      "/dev/nvidiactl rw"
      "/dev/nvidia-uvm rw"
      "/dev/nvidia-uvm-tools rw"
      "/dev/nvidia-modeset rw"
    ];
  };

  services.jellyfin = {
    enable = true;

    # Upstream has started mapping these settings, so ho
    # we'll be able to kill a range of our bespoke options
    useDeclarativeSettings = true;

    user = "jellyfin";
    group = "media";

    hardwareAcceleration = {
      enable = true;
      device = "/dev/nvidia0";
      type = "nvenc";
    };

    forceEncodingConfig = true;

    openFirewall = true;

    transcoding = {
      deleteSegments = true;
      enableHardwareEncoding = true;
      enableSubtitleExtraction = true;
      enableToneMapping = true;
      encodingPreset = "auto";

      hardwareDecodingCodecs = {
        av1 = true;
        h264 = true;
        hevc = true;
        hevc10bit = true;
        hevcRExt10bit = true;
        hevcRExt12bit = true;
        mpeg2 = true;
        vc1 = true;
        vp8 = true;
        vp9 = true;
      };
      hardwareEncodingCodecs = {
        av1 = true;
        hevc = true;
      };
      throttleTranscoding = true;
    };

    network-settings = {
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
          value = config.services.jellyfin.ports.https;
        }
        {
          name = "HttpServerPortNumber";
          value = config.services.jellyfin.ports.http;
        }
        {
          name = "HttpsPortNumber";
          value = config.services.jellyfin.ports.https;
        }
        {
          name = "EnableHttps";
          value = true;
        }
        {
          name = "PublicPort";
          value = config.services.jellyfin.ports.http;
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
        {
          name = "KnownProxies";
          value = [
            {
              name = "string";
              value = self.common.config.services.nginx.ipv4;
            }
          ];
        }
        {
          name = "EnablePublishedServerUriByRequest";
          value = false;
        }
      ];
    };

  };
}
