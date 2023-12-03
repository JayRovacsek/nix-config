{ cfg, config }: {
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
      value = "Legacy";
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
      name = "ImageExtractionTimeoutMs";
      value = 0;
    }
    { name = "PathSubstitutions"; }
    {
      name = "EnableSlowResponseWarning";
      value = true;
    }
    {
      name = "SlowResponseThresholdMs";
      value = 500;
    }
    {
      name = "CorsHosts";
      value = [{
        name = "string";
        value = "*";
      }];
    }
    {
      name = "ActivityLogRetentionDays";
      value = 30;
    }
    {
      name = "LibraryScanFanoutConcurrency";
      value = 0;
    }
    {
      name = "LibraryMetadataRefreshConcurrency";
      value = 0;
    }
    {
      name = "RemoveOldPlugins";
      value = false;
    }
    {
      name = "AllowClientLogUpload";
      value = true;
    }
  ];
}
