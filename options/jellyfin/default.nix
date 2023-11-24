{ config, lib, ... }:

with lib;

let
  cfg = config.services.jellyfin;
  inherit (config.flake.lib.xml) to-basic-xml;
  CacheDirectory = "jellyfin";
in {
  options = {
    services.jellyfin = {
      http-port = mkOption {
        type = types.port;
        default = 8096;
      };

      https-port = mkOption {
        type = types.port;
        default = 8920;
      };

      data-dir = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          Jellyfin datadir location.
        '';
      };

      cache-dir = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          Jellyfin cachedir location.
        '';
      };

      metadata-dir = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          Jellyfin metadata location.
        '';
      };

      system-settings = mkOption {
        type = types.attrs;
        default = {
          name = "ServerConfiguration";
          props = ''
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"'';

          children = [
            {
              name = "LogFileRetentionDays";
              children = 3;
            }
            {
              name = "IsStartupWizardCompleted";
              children = "true";
            }
            {
              name = "EnableMetrics";
              children = "false";
            }
            {
              name = "EnableNormalizedItemByNameIds";
              children = "true";
            }
            {
              name = "IsPortAuthorized";
              children = "true";
            }
            {
              name = "AutoRunWebApp";
              children = "true";
            }
            {
              name = "QuickConnectAvailable";
              children = "true";
            }
            {
              name = "EnableCaseSensitiveItemIds";
              children = "true";
            }
            {
              name = "DisableLiveTvChannelUserDataName";
              children = "true";
            }
            {
              name = "MetadataPath";
              children = cfg.metadata-dir;
            }
            { name = "MetadataNetworkPath"; }
            {
              name = "PreferredMetadataLanguage";
              children = "en";
            }
            {
              name = "MetadataCountryCode";
              children = "AU";
            }
            {
              name = "SortReplaceCharacters";
              children = [
                {
                  name = "string";
                  children = ".";
                }
                {
                  name = "string";
                  children = "+";
                }
                {
                  name = "string";
                  children = "%";
                }
              ];
            }
            {
              name = "SortRemoveCharacters";
              children = [
                {
                  name = "string";
                  children = ",";
                }
                {
                  name = "string";
                  children = "&amp;";
                }
                {
                  name = "string";
                  children = "-";
                }
                {
                  name = "string";
                  children = "{";
                }
                {
                  name = "string";
                  children = "}";
                }
                {
                  name = "string";
                  children = "'";
                }
              ];
            }
            {
              name = "SortRemoveWords";
              children = [
                {
                  name = "string";
                  children = "the";
                }
                {
                  name = "string";
                  children = "a";
                }
                {
                  name = "string";
                  children = "an";
                }
              ];
            }
            {
              name = "MinResumePct";
              children = 5;
            }
            {
              name = "MaxResumePct";
              children = 90;
            }
            {
              name = "MinResumeDurationSeconds";
              children = 300;
            }
            {
              name = "MinAudiobookResume";
              children = 5;
            }
            {
              name = "MaxAudiobookResume";
              children = 5;
            }
            {
              name = "LibraryMonitorDelay";
              children = 60;
            }
            {
              name = "EnableDashboardResponseCaching";
              children = "true";
            }
            {
              name = "ImageSavingConvention";
              children = "Compatible";
            }
            {
              name = "MetadataOptions";
              children = [
                {
                  name = "MetadataOptions";
                  children = [
                    {
                      name = "ItemType";
                      children = "Book";
                    }
                    { name = "DisabledMetadataSavers"; }
                    { name = "LocalMetadataReaderOrder"; }
                    { name = "DisabledMetadataFetchers"; }
                    { name = "MetadataFetcherOrder"; }
                    { name = "DisabledImageFetchers"; }
                    { name = "ImageFetcherOrder"; }
                  ];
                }
                {
                  name = "MetadataOptions";
                  children = [
                    {
                      name = "ItemType";
                      children = "Movie";
                    }
                    { name = "DisabledMetadataSavers"; }
                    { name = "LocalMetadataReaderOrder"; }
                    { name = "DisabledMetadataFetchers"; }
                    { name = "MetadataFetcherOrder"; }
                    { name = "DisabledImageFetchers"; }
                    { name = "ImageFetcherOrder"; }
                  ];
                }
                {
                  name = "MetadataOptions";
                  children = [
                    {
                      name = "ItemType";
                      children = "MusicVideo";
                    }
                    { name = "DisabledMetadataSavers"; }
                    { name = "LocalMetadataReaderOrder"; }
                    {
                      name = "DisabledMetadataFetchers";
                      children = [{
                        name = "string";
                        children = "The Open Movie Database";
                      }];
                    }
                    { name = "MetadataFetcherOrder"; }
                    {
                      name = "DisabledImageFetchers";
                      children = [{
                        name = "string";
                        children = "The Open Movie Database";
                      }];
                    }
                    { name = "ImageFetcherOrder"; }
                  ];
                }
                {
                  name = "MetadataOptions";
                  children = [
                    {
                      name = "ItemType";
                      children = "Series";
                    }
                    { name = "DisabledMetadataSavers"; }
                    { name = "LocalMetadataReaderOrder"; }
                    {
                      name = "DisabledMetadataFetchers";
                      children = [{
                        name = "string";
                        children = "TheMovieDb";
                      }];
                    }
                    { name = "MetadataFetcherOrder"; }
                    {
                      name = "DisabledImageFetchers";
                      children = [{
                        name = "string";
                        children = "TheMovieDb";
                      }];
                    }
                    { name = "ImageFetcherOrder"; }
                  ];
                }
                {
                  name = "MetadataOptions";
                  children = [
                    {
                      name = "ItemType";
                      children = "MusicAlbum";
                    }
                    { name = "DisabledMetadataSavers"; }
                    { name = "LocalMetadataReaderOrder"; }
                    {
                      name = "DisabledMetadataFetchers";
                      children = [{
                        name = "string";
                        children = "TheAudioDB";
                      }];
                    }
                    { name = "MetadataFetcherOrder"; }
                    { name = "DisabledImageFetchers"; }
                    { name = "ImageFetcherOrder"; }
                  ];
                }
                {
                  name = "MetadataOptions";
                  children = [
                    {
                      name = "ItemType";
                      children = "MusicArtist";
                    }
                    { name = "DisabledMetadataSavers"; }
                    { name = "LocalMetadataReaderOrder"; }
                    {
                      name = "DisabledMetadataFetchers";
                      children = [{
                        name = "string";
                        children = "TheAudioDB";
                      }];
                    }
                    { name = "MetadataFetcherOrder"; }
                    { name = "DisabledImageFetchers"; }
                    { name = "ImageFetcherOrder"; }
                  ];
                }
                {
                  name = "MetadataOptions";
                  children = [
                    {
                      name = "ItemType";
                      children = "BoxSet";
                    }
                    { name = "DisabledMetadataSavers"; }
                    { name = "LocalMetadataReaderOrder"; }
                    { name = "DisabledMetadataFetchers"; }
                    { name = "MetadataFetcherOrder"; }
                    { name = "DisabledImageFetchers"; }
                    { name = "ImageFetcherOrder"; }
                  ];
                }
                {
                  name = "MetadataOptions";
                  children = [
                    {
                      name = "ItemType";
                      children = "Season";
                    }
                    { name = "DisabledMetadataSavers"; }
                    { name = "LocalMetadataReaderOrder"; }
                    {
                      name = "DisabledMetadataFetchers";
                      children = [{
                        name = "string";
                        children = "TheMovieDb";
                      }];
                    }
                    { name = "MetadataFetcherOrder"; }
                    { name = "DisabledImageFetchers"; }
                    { name = "ImageFetcherOrder"; }
                  ];
                }
                {
                  name = "MetadataOptions";
                  children = [
                    {
                      name = "ItemType";
                      children = "Episode";
                    }
                    { name = "DisabledMetadataSavers"; }
                    { name = "LocalMetadataReaderOrder"; }
                    {
                      name = "DisabledMetadataFetchers";
                      children = [
                        {
                          name = "string";
                          children = "The Open Movie Database";
                        }
                        {
                          name = "string";
                          children = "TheMovieDb";
                        }
                      ];
                    }
                    { name = "MetadataFetcherOrder"; }
                    {
                      name = "DisabledImageFetchers";
                      children = [
                        {
                          name = "string";
                          children = "The Open Movie Database";
                        }
                        {
                          name = "string";
                          children = "TheMovieDb";
                        }
                      ];
                    }
                    { name = "ImageFetcherOrder"; }
                  ];
                }
              ];
            }
            {
              name = "SkipDeserializationForBasicTypes";
              children = "true";
            }
            {
              name = "ServerName";
              children = config.networking.hostName;
            }
            {
              name = "UICulture";
              children = "en-GB";
            }
            {
              name = "SaveMetadataHidden";
              children = "false";
            }
            { name = "ContentTypes"; }
            {
              name = "RemoteClientBitrateLimit";
              children = 20000000;
            }
            {
              name = "EnableFolderView";
              children = "false";
            }
            {
              name = "EnableGroupingIntoCollections";
              children = "false";
            }
            {
              name = "DisplaySpecialsWithinSeasons";
              children = "true";
            }
            { name = "CodecsUsed"; }
            {
              name = "PluginRepositories";
              children = [{
                name = "RepositoryInfo";
                children = [
                  {
                    name = "Name";
                    children = "Jellyfin Stable";
                  }
                  {
                    name = "Url";
                    children =
                      "https://repo.jellyfin.org/releases/plugin/manifest-stable.json";
                  }
                ];
              }];
            }
            {
              name = "EnableExternalContentInSuggestions";
              children = "true";
            }
            {
              name = "EnableNewOmdbSupport";
              children = "true";
            }
            {
              name = "ImageExtractionTimeoutMs";
              children = 0;
            }
            { name = "PathSubstitutions"; }
            {
              name = "EnableSimpleArtistDetection";
              children = "true";
            }
            { name = "UninstalledPlugins"; }
          ];
        };
        description = lib.mdDoc "System settings for Jellyfin.";
      };

      encoding-settings = mkOption {
        type = types.attrs;
        default = {
          name = "EncodingOptions";
          props = ''
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"'';

          children = [
            {
              name = "EncodingThreadCount";
              children = 0;
            }
            { name = "TranscodingTempPath"; }
            {
              name = "DownMixAudioBoost";
              children = 2;
            }
            {
              name = "EnableThrottling";
              children = "true";
            }
            {
              name = "ThrottleDelaySeconds";
              children = 180;
            }
            {
              name = "HardwareAccelerationType";
              # TODO: make this dynamic depending on system capabilities
              children = "nvenc";
            }
            {
              name = "H264Crf";
              children = 23;
            }
            {
              name = "H265Crf";
              children = 28;
            }
            { name = "EncoderPreset"; }
            {
              name = "DeinterlaceMethod";
              children = "yadif";
            }
            {
              name = "EnableDecodingColorDepth10Hevc";
              children = "true";
            }
            {
              name = "EnableDecodingColorDepth10Vp9";
              children = "true";
            }
            {
              name = "EnableHardwareEncoding";
              children = "true";
            }
            {
              name = "EnableSubtitleExtraction";
              children = "true";
            }
            {
              name = "HardwareDecodingCodecs";
              children = [
                {
                  name = "string";
                  children = "h264";
                }
                {
                  name = "string";
                  children = "hevc";
                }
                {
                  name = "string";
                  children = "mpeg2video";
                }
                {
                  name = "string";
                  children = "mpeg4";
                }
                {
                  name = "string";
                  children = "vc1";
                }
                {
                  name = "string";
                  children = "vp8";
                }
                {
                  name = "string";
                  children = "vp9";
                }
              ];
            }
          ];
        };
        description = lib.mdDoc "Encoding settings for Jellyfin.";
      };

      network-settings = mkOption {
        type = types.attrs;
        default = {
          name = "NetworkConfiguration";
          props = ''
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"'';

          children = [
            {
              name = "RequireHttps";
              children = "false";
            }
            { name = "CertificatePath"; }
            { name = "CertificatePassword"; }
            { name = "BaseUrl"; }
            {
              name = "PublicHttpsPort";
              children = cfg.https-port;
            }
            {
              name = "HttpServerPortNumber";
              children = cfg.http-port;
            }
            {
              name = "HttpsPortNumber";
              children = cfg.https-port;
            }
            {
              name = "EnableHttps";
              children = "true";
            }
            {
              name = "PublicPort";
              children = cfg.http-port;
            }
            {
              name = "UPnPCreateHttpPortMap";
              children = "false";
            }
            { name = "UDPPortRange"; }
            {
              name = "EnableIPV6";
              children = "false";
            }
            {
              name = "EnableIPV6";
              children = "true";
            }
            {
              name = "EnableSSDPTracing";
              children = "false";
            }
            { name = "SSDPTracingFilter"; }
            {
              name = "UDPSendCount";
              children = 2;
            }
            {
              name = "UDPSendCount";
              children = 100;
            }
            {
              name = "IgnoreVirtualInterfaces";
              children = "true";
            }
            {
              name = "VirtualInterfaceNames";
              children = "vEthernet*";
            }
            {
              name = "GatewayMonitorPeriod";
              children = 60;
            }
            {
              name = "TrustAllIP6Interfaces";
              children = "false";
            }
            { name = "HDHomerunPortRange"; }
            { name = "PublishedServerUriBySubnet"; }
            {
              name = "IgnoreVirtualInterfaces";
              children = "false";
            }
            {
              name = "AutoDiscoveryTracing";
              children = "false";
            }
            {
              name = "AutoDiscovery";
              children = "false";
            }
            { name = "RemoteIPFilter"; }
            {
              name = "IsRemoteIPFilterBlacklist";
              children = "true";
            }
            {
              name = "EnableUPnP";
              children = "false";
            }
            {
              name = "EnableRemoteAccess";
              children = "true";
            }
            {
              name = "LocalNetworkSubnets";
              children = [
                {
                  name = "string";
                  children = "192.168.1.0/24";
                }
                {
                  name = "string";
                  children = "192.168.2.0/24";
                }
                {
                  name = "string";
                  children = "192.168.3.0/24";
                }
                {
                  name = "string";
                  children = "192.168.5.0/24";
                }
                {
                  name = "string";
                  children = "192.168.7.0/24";
                }
                {
                  name = "string";
                  children = "192.168.8.0/24";
                }
              ];
            }
            { name = "LocalNetworkAddresses"; }
            { name = "KnownProxies"; }
            {
              name = "EnablePublishedServerUriByRequest";
              children = "false";
            }
          ];
        };
        description = lib.mdDoc "Networking settings for Jellyfin.";
      };
    };
  };

  config = mkIf cfg.enable {

    networking.firewall = mkIf cfg.openFirewall {
      # from https://jellyfin.org/docs/general/networking/#port-bindings
      # we've simply made the http/https options configurable via code
      allowedTCPPorts = [ cfg.http-port cfg.https-port ];
    };

    systemd.services.jellyfin = {
      serviceConfig = rec {
        inherit CacheDirectory;
        ExecStart = lib.mkForce "${cfg.package}/bin/jellyfin --datadir '${
            if cfg.data-dir == null then
              "/var/lib/${CacheDirectory}"
            else
              cfg.data-dir
          }' --cachedir '${
            if cfg.cache-dir == null then
              "/var/cache/${CacheDirectory}"
            else
              cfg.cache-dir
          }'";
      };
    };

    environment.etc."jellyfin/config/system.xml" = {
      inherit (cfg) user group;
      text = to-basic-xml cfg.system-settings;
      mode = "660";
    };

    environment.etc."jellyfin/config/encoding.xml" = {
      inherit (cfg) user group;
      text = to-basic-xml cfg.encoding-settings;
      mode = "660";
    };

    environment.etc."jellyfin/config/network.xml" = {
      inherit (cfg) user group;
      text = to-basic-xml cfg.network-settings;
      mode = "660";
    };

    systemd.tmpfiles.rules = let
      config-dir = if cfg.data-dir == null then
        "/var/lib/${CacheDirectory}/config"
      else
        "${cfg.data-dir}/config";
    in [
      "L+ ${config-dir}/system.xml - - - - /etc/jellyfin/config/system.xml"
      "L+ ${config-dir}/encoding.xml - - - - /etc/jellyfin/config/encoding.xml"
      "L+ ${config-dir}/network.xml - - - - /etc/jellyfin/config/network.xml"
    ];
  };
}
