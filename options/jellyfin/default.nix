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
          value = [
            {
              name = "LogFileRetentionDays";
              value = 14;
            }
            {
              name = "IsStartupWizardCompleted";
              value = true;
            }
            {
              name = "EnableMetrics";
              value = false;
            }
            {
              name = "EnableNormalizedItemByNameIds";
              value = true;
            }
            {
              name = "IsPortAuthorized";
              value = true;
            }
            {
              name = "AutoRunWebApp";
              value = true;
            }
            {
              name = "QuickConnectAvailable";
              value = true;
            }
            {
              name = "EnableCaseSensitiveItemIds";
              value = true;
            }
            {
              name = "DisableLiveTvChannelUserDataName";
              value = true;
            }
            {
              name = "MetadataPath";
              value = cfg.metadata-dir;
            }
            { name = "MetadataNetworkPath"; }
            {
              name = "PreferredMetadataLanguage";
              value = "en";
            }
            {
              name = "MetadataCountryCode";
              value = "AU";
            }
            {
              name = "SortReplaceCharacters";
              value = [
                {
                  name = "string";
                  value = ".";
                }
                {
                  name = "string";
                  value = "+";
                }
                {
                  name = "string";
                  value = "%";
                }
              ];
            }
            {
              name = "SortRemoveCharacters";
              value = [
                {
                  name = "string";
                  value = ",";
                }
                {
                  name = "string";
                  value = "&amp;";
                }
                {
                  name = "string";
                  value = "-";
                }
                {
                  name = "string";
                  value = "{";
                }
                {
                  name = "string";
                  value = "}";
                }
                {
                  name = "string";
                  value = "'";
                }
              ];
            }
            {
              name = "SortRemoveWords";
              value = [
                {
                  name = "string";
                  value = "the";
                }
                {
                  name = "string";
                  value = "a";
                }
                {
                  name = "string";
                  value = "an";
                }
              ];
            }
            {
              name = "MinResumePct";
              value = 5;
            }
            {
              name = "MaxResumePct";
              value = 90;
            }
            {
              name = "MinResumeDurationSeconds";
              value = 300;
            }
            {
              name = "MinAudiobookResume";
              value = 5;
            }
            {
              name = "MaxAudiobookResume";
              value = 5;
            }
            {
              name = "LibraryMonitorDelay";
              value = 60;
            }
            {
              name = "EnableDashboardResponseCaching";
              value = true;
            }
            {
              name = "ImageSavingConvention";
              value = "Compatible";
            }
            {
              name = "MetadataOptions";
              value = [
                {
                  name = "MetadataOptions";
                  value = [
                    {
                      name = "ItemType";
                      value = "Book";
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
                  value = [
                    {
                      name = "ItemType";
                      value = "Movie";
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
                  value = [
                    {
                      name = "ItemType";
                      value = "MusicVideo";
                    }
                    { name = "DisabledMetadataSavers"; }
                    { name = "LocalMetadataReaderOrder"; }
                    {
                      name = "DisabledMetadataFetchers";
                      value = [{
                        name = "string";
                        value = "The Open Movie Database";
                      }];
                    }
                    { name = "MetadataFetcherOrder"; }
                    {
                      name = "DisabledImageFetchers";
                      value = [{
                        name = "string";
                        value = "The Open Movie Database";
                      }];
                    }
                    { name = "ImageFetcherOrder"; }
                  ];
                }
                {
                  name = "MetadataOptions";
                  value = [
                    {
                      name = "ItemType";
                      value = "Series";
                    }
                    { name = "DisabledMetadataSavers"; }
                    { name = "LocalMetadataReaderOrder"; }
                    {
                      name = "DisabledMetadataFetchers";
                      value = [{
                        name = "string";
                        value = "TheMovieDb";
                      }];
                    }
                    { name = "MetadataFetcherOrder"; }
                    {
                      name = "DisabledImageFetchers";
                      value = [{
                        name = "string";
                        value = "TheMovieDb";
                      }];
                    }
                    { name = "ImageFetcherOrder"; }
                  ];
                }
                {
                  name = "MetadataOptions";
                  value = [
                    {
                      name = "ItemType";
                      value = "MusicAlbum";
                    }
                    { name = "DisabledMetadataSavers"; }
                    { name = "LocalMetadataReaderOrder"; }
                    {
                      name = "DisabledMetadataFetchers";
                      value = [{
                        name = "string";
                        value = "TheAudioDB";
                      }];
                    }
                    { name = "MetadataFetcherOrder"; }
                    { name = "DisabledImageFetchers"; }
                    { name = "ImageFetcherOrder"; }
                  ];
                }
                {
                  name = "MetadataOptions";
                  value = [
                    {
                      name = "ItemType";
                      value = "MusicArtist";
                    }
                    { name = "DisabledMetadataSavers"; }
                    { name = "LocalMetadataReaderOrder"; }
                    {
                      name = "DisabledMetadataFetchers";
                      value = [{
                        name = "string";
                        value = "TheAudioDB";
                      }];
                    }
                    { name = "MetadataFetcherOrder"; }
                    { name = "DisabledImageFetchers"; }
                    { name = "ImageFetcherOrder"; }
                  ];
                }
                {
                  name = "MetadataOptions";
                  value = [
                    {
                      name = "ItemType";
                      value = "BoxSet";
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
                  value = [
                    {
                      name = "ItemType";
                      value = "Season";
                    }
                    { name = "DisabledMetadataSavers"; }
                    { name = "LocalMetadataReaderOrder"; }
                    {
                      name = "DisabledMetadataFetchers";
                      value = [{
                        name = "string";
                        value = "TheMovieDb";
                      }];
                    }
                    { name = "MetadataFetcherOrder"; }
                    { name = "DisabledImageFetchers"; }
                    { name = "ImageFetcherOrder"; }
                  ];
                }
                {
                  name = "MetadataOptions";
                  value = [
                    {
                      name = "ItemType";
                      value = "Episode";
                    }
                    { name = "DisabledMetadataSavers"; }
                    { name = "LocalMetadataReaderOrder"; }
                    {
                      name = "DisabledMetadataFetchers";
                      value = [
                        {
                          name = "string";
                          value = "The Open Movie Database";
                        }
                        {
                          name = "string";
                          value = "TheMovieDb";
                        }
                      ];
                    }
                    { name = "MetadataFetcherOrder"; }
                    {
                      name = "DisabledImageFetchers";
                      value = [
                        {
                          name = "string";
                          value = "The Open Movie Database";
                        }
                        {
                          name = "string";
                          value = "TheMovieDb";
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
              value = true;
            }
            {
              name = "ServerName";
              value = config.networking.hostName;
            }
            {
              name = "UICulture";
              value = "en-GB";
            }
            {
              name = "SaveMetadataHidden";
              value = false;
            }
            { name = "ContentTypes"; }
            {
              name = "RemoteClientBitrateLimit";
              value = 20000000;
            }
            {
              name = "EnableFolderView";
              value = false;
            }
            {
              name = "EnableGroupingIntoCollections";
              value = false;
            }
            {
              name = "DisplaySpecialsWithinSeasons";
              value = true;
            }
            { name = "CodecsUsed"; }
            {
              name = "PluginRepositories";
              value = [{
                name = "RepositoryInfo";
                value = [
                  {
                    name = "Name";
                    value = "Jellyfin Stable";
                  }
                  {
                    name = "Url";
                    value =
                      "https://repo.jellyfin.org/releases/plugin/manifest-stable.json";
                  }
                ];
              }];
            }
            {
              name = "EnableExternalContentInSuggestions";
              value = true;
            }
            {
              name = "EnableNewOmdbSupport";
              value = true;
            }
            {
              name = "ImageExtractionTimeoutMs";
              value = 0;
            }
            { name = "PathSubstitutions"; }
            {
              name = "EnableSimpleArtistDetection";
              value = true;
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

          value = [
            {
              name = "EncodingThreadCount";
              value = 0;
            }
            { name = "TranscodingTempPath"; }
            {
              name = "DownMixAudioBoost";
              value = 2;
            }
            {
              name = "EnableThrottling";
              value = true;
            }
            {
              name = "ThrottleDelaySeconds";
              value = 180;
            }
            {
              name = "HardwareAccelerationType";
              # TODO: make this dynamic depending on system capabilities
              value = "nvenc";
            }
            {
              name = "H264Crf";
              value = 23;
            }
            {
              name = "H265Crf";
              value = 28;
            }
            { name = "EncoderPreset"; }
            {
              name = "DeinterlaceMethod";
              value = "yadif";
            }
            {
              name = "EnableDecodingColorDepth10Hevc";
              value = true;
            }
            {
              name = "EnableDecodingColorDepth10Vp9";
              value = true;
            }
            {
              name = "EnableHardwareEncoding";
              value = true;
            }
            {
              name = "AllowHevcEncoding";
              value = true;
            }
            {
              name = "EnableSubtitleExtraction";
              value = true;
            }
            {
              name = "HardwareDecodingCodecs";
              value = [
                {
                  name = "string";
                  value = "h264";
                }
                {
                  name = "string";
                  value = "hevc";
                }
                {
                  name = "string";
                  value = "mpeg2video";
                }
                {
                  name = "string";
                  value = "mpeg4";
                }
                {
                  name = "string";
                  value = "vc1";
                }
                {
                  name = "string";
                  value = "vp8";
                }
                {
                  name = "string";
                  value = "vp9";
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
              value = cfg.https-port;
            }
            {
              name = "HttpServerPortNumber";
              value = cfg.http-port;
            }
            {
              name = "HttpsPortNumber";
              value = cfg.https-port;
            }
            {
              name = "EnableHttps";
              value = true;
            }
            {
              name = "PublicPort";
              value = cfg.http-port;
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
        };
        description = lib.mdDoc "Networking settings for Jellyfin.";
      };

      notification-settings = mkOption {
        type = types.attrs;
        default = {
          name = "NotificationOptions";
          props = ''
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"'';

          value = [{
            name = "Options";
            value = builtins.map (x: {
              name = x;
              value = [
                {
                  name = "Type";
                  value = "TaskFailed";
                }
                { name = "DisabledMonitorUsers"; }
                { name = "SendToUsers"; }
                {
                  name = "Enabled";
                  value = true;
                }
                { name = "DisabledServices"; }
                {
                  name = "SendToUserMode";
                  value = "Admins";
                }
              ];
            }) [
              "TaskFailed"
              "ServerRestartRequired"
              "ApplicationUpdateAvailable"
              "ApplicationUpdateInstalled"
              "PluginUpdateInstalled"
              "PluginUninstalled"
              "InstallationFailed"
              "PluginInstalled"
              "PluginError"
              "UserLockedOut"
              "VideoPlayback"
            ];
          }];
        };
        description = lib.mdDoc "Notification settings for Jellyfin.";
      };

      logging-settings = mkOption {
        type = types.attrs;
        default = {
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
                  outputTemplate =
                    "[{Timestamp:HH:mm:ss}] [{Level:u3}] [{ThreadId}] {SourceContext}= {Message:lj}{NewLine}{Exception}";
                };
              }
              {
                Name = "Async";
                Args = {
                  configure = [{
                    Name = "File";
                    Args = {
                      path = "%JELLYFIN_LOG_DIR%//log_.log";
                      rollingInterval = "Day";
                      retainedFileCountLimit = 3;
                      rollOnFileSizeLimit = true;
                      fileSizeLimitBytes = 100000000;
                      outputTemplate =
                        "[{Timestamp:yyyy-MM-dd HH:mm:ss.fff zzz}] [{Level:u3}] [{ThreadId}] {SourceContext}= {Message}{NewLine}{Exception}";
                    };
                  }];
                };
              }
            ];
            Enrich = [ "FromLogContext" "WithThreadId" ];
          };
        };
        description = lib.mdDoc "Logging settings for Jellyfin.";
      };

      dlna-settings = mkOption {
        type = types.attrs;
        default = {
          name = "DlnaOptions";
          props = ''
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"'';

          value = [
            {
              name = "EnablePlayTo";
              value = false;
            }
            {
              name = "EnableServer";
              value = false;
            }
            {
              name = "EnableDebugLog";
              value = false;
            }
            {
              name = "BlastAliveMessages";
              value = false;
            }
            {
              name = "SendOnlyMatchedHost";
              value = true;
            }
            {
              name = "ClientDiscoveryIntervalSeconds";
              value = 60;
            }
            {
              name = "BlastAliveMessageIntervalSeconds";
              value = 1800;
            }
          ];
        };
        description = lib.mdDoc "DLNA settings for Jellyfin.";
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
      mode = "640";
    };

    environment.etc."jellyfin/config/encoding.xml" = {
      inherit (cfg) user group;
      text = to-basic-xml cfg.encoding-settings;
      mode = "640";
    };

    environment.etc."jellyfin/config/network.xml" = {
      inherit (cfg) user group;
      text = to-basic-xml cfg.network-settings;
      mode = "640";
    };

    environment.etc."jellyfin/config/notifications.xml" = {
      inherit (cfg) user group;
      text = to-basic-xml cfg.notification-settings;
      mode = "640";
    };

    environment.etc."jellyfin/config/dlna.xml" = {
      inherit (cfg) user group;
      text = to-basic-xml cfg.dlna-settings;
      mode = "640";
    };

    environment.etc."jellyfin/config/logging-default.json" = {
      inherit (cfg) user group;
      text = builtins.toJSON cfg.logging-settings;
      mode = "640";
    };

    systemd.tmpfiles.rules = let
      config-dir = if cfg.data-dir == null then
        "/var/lib/${CacheDirectory}/config"
      else
        "${cfg.data-dir}/config";
    in [
      "L+ ${config-dir}/dlna.xml - - - - /etc/jellyfin/config/dlna.xml"
      "L+ ${config-dir}/encoding.xml - - - - /etc/jellyfin/config/encoding.xml"
      "L+ ${config-dir}/logging-default.json - - - - /etc/jellyfin/config/logging-default.json"
      "L+ ${config-dir}/network.xml - - - - /etc/jellyfin/config/network.xml"
      "L+ ${config-dir}/notifications.xml - - - - /etc/jellyfin/config/notifications.xml"
      "L+ ${config-dir}/system.xml - - - - /etc/jellyfin/config/system.xml"
    ];
  };
}
