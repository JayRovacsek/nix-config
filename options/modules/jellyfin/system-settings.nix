{ config, ... }:
{
  name = "ServerConfiguration";
  props = ''xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"'';
  value = [
    {
      name = "ActivityLogRetentionDays";
      value = 30;
    }
    {
      name = "AllowClientLogUpload";
      value = true;
    }
    {
      name = "AutoRunWebApp";
      value = true;
    }
    { name = "CastReceiverApplications"; }
    {
      name = "ChapterImageResolution";
      value = "MatchSource";
    }
    { name = "CodecsUsed"; }
    { name = "ContentTypes"; }
    {
      name = "CorsHosts";
      value = [
        {
          name = "string";
          value = "*";
        }
      ];
    }
    {
      name = "DisableLiveTvChannelUserDataName";
      value = true;
    }
    {
      name = "DisplaySpecialsWithinSeasons";
      value = true;
    }
    {
      name = "DummyChapterDuration";
      value = 0;
    }
    {
      name = "EnableCaseSensitiveItemIds";
      value = true;
    }
    {
      name = "EnableExternalContentInSuggestions";
      value = true;
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
      name = "EnableMetrics";
      value = false;
    }
    {
      name = "EnableNormalizedItemByNameIds";
      value = true;
    }
    {
      name = "EnableSlowResponseWarning";
      value = true;
    }
    {
      name = "ImageExtractionTimeoutMs";
      value = 0;
    }
    {
      name = "ImageSavingConvention";
      value = "Legacy";
    }
    {
      name = "InactiveSessionThreshold";
      value = 0;
    }
    {
      name = "IsPortAuthorized";
      value = true;
    }
    {
      name = "IsStartupWizardCompleted";
      value = true;
    }
    {
      name = "LibraryMetadataRefreshConcurrency";
      value = 0;
    }
    {
      name = "LibraryMonitorDelay";
      value = 60;
    }
    {
      name = "LibraryScanFanoutConcurrency";
      value = 0;
    }
    {
      name = "LibraryUpdateDuration";
      value = 30;
    }
    {
      name = "LogFileRetentionDays";
      value = 14;
    }
    {
      name = "MaxAudiobookResume";
      value = 5;
    }
    {
      name = "MaxResumePct";
      value = 90;
    }
    {
      name = "MetadataCountryCode";
      value = "AU";
    }
    { name = "MetadataNetworkPath"; }
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
              value = [
                {
                  name = "string";
                  value = "The Open Movie Database";
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
              ];
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
              value = [
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
                  value = "TheMovieDb";
                }
              ];
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
              value = [
                {
                  name = "string";
                  value = "TheAudioDB";
                }
              ];
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
              value = [
                {
                  name = "string";
                  value = "TheAudioDB";
                }
              ];
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
              value = [
                {
                  name = "string";
                  value = "TheMovieDb";
                }
              ];
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
    { name = "MetadataPath"; }
    {
      name = "MinAudiobookResume";
      value = 5;
    }
    {
      name = "MinResumeDurationSeconds";
      value = 300;
    }
    {
      name = "MinResumePct";
      value = 5;
    }
    {
      name = "ParallelImageEncodingLimit";
      value = 0;
    }
    { name = "PathSubstitutions"; }
    {
      name = "PluginRepositories";
      value = [
        {
          name = "RepositoryInfo";
          value = [
            {
              name = "Enabled";
              value = true;
            }
            {
              name = "Name";
              value = "Jellyfin Stable";
            }
            {
              name = "Url";
              value = "https://repo.jellyfin.org/releases/plugin/manifest-stable.json";
            }
          ];
        }
      ];
    }
    {
      name = "PreferredMetadataLanguage";
      value = "en";
    }
    {
      name = "QuickConnectAvailable";
      value = true;
    }
    {
      name = "RemoteClientBitrateLimit";
      value = 100000000;
    }
    {
      name = "RemoveOldPlugins";
      value = false;
    }
    {
      name = "SaveMetadataHidden";
      value = false;
    }
    {
      name = "ServerName";
      value = config.networking.hostName;
    }
    {
      name = "SkipDeserializationForBasicTypes";
      value = true;
    }
    {
      name = "SlowResponseThresholdMs";
      value = 500;
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
      name = "TrickplayOptions";
      value = [
        {
          name = "EnableHwAcceleration";
          value = true;
        }
        {
          name = "EnableHwEncoding";
          value = true;
        }
        {
          name = "EnableKeyFrameOnlyExtraction";
          value = true;
        }
        {
          name = "ScanBehavior";
          value = "NonBlocking";
        }
        {
          name = "ProcessPriority";
          value = "BelowNormal";
        }
        {
          name = "Interval";
          value = 10000;
        }
        {
          name = "WidthResolutions";
          value = [
            {
              name = "int";
              value = 320;
            }
          ];
        }
        {
          name = "TileWidth";
          value = 10;
        }
        {
          name = "TileHeight";
          value = 10;
        }
        {
          name = "Qscale";
          value = 4;
        }
        {
          name = "JpegQuality";
          value = 90;
        }
        {
          name = "ProcessThreads";
          value = 1;
        }
        {
          name = "Interval";
          value = 10000;
        }
      ];
    }
    {
      name = "UICulture";
      value = "en-GB";
    }
  ];
}
