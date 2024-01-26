{ config, lib, pkgs, ... }: {
  # Required to generate the json file describing how firefox
  # can interact with keepassxc
  programs.firefox.nativeMessagingHosts = with pkgs; [ keepassxc ];

  home = {
    # Generate a suitable configuration that applies opinionated defaults    
    file."${config.xdg.configHome}/keepassxc/keepassxc.ini".text =
      lib.generators.toINI { } {
        General = {
          AutoTypeHideExpiredEntry = true;
          ConfigVersion = 2;
          UseAtomicSaves = false;
        };

        Browser = {
          CustomProxyLocation = "";
          Enabled = true;
          SearchInAllDatabases = true;
        };

        GUI = {
          ApplicationTheme = "dark";
          MinimizeOnClose = true;
          MinimizeOnStartup = true;
          MinimizeToTray = true;
          ShowTrayIcon = true;
          TrayIconAppearance = "monochrome-light";
        };

        KeeShare = {
          Active = ''
            <?xml version="1.0"?><KeeShare><Active/></KeeShare>
          '';
          Foreign = ''
            <?xml version="1.0"?>
            <KeeShare xmlns:xsd="http://www.w3.org/2001/XMLSchema"xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
              <Foreign/>
            </KeeShare>
          '';
          Own = ''
            <?xml version="1.0"?><KeeShare></PrivateKey></PublicKey></KeeShare>
          '';
          QuietSuccess = true;
        };

        PasswordGenerator = {
          AdditionalChars = "";
          AdvancedMode = true;
          ExcludedChars = "";
          Length = 32;
          Logograms = false;
          SpecialChars = true;
          Type = 0;
          WordCase = 2;
          WordCount = 3;
          WordSeparator = " ";
        };

        Security.IconDownloadFallback = true;
      };
    packages = with pkgs; [ keepassxc ];
  };
}
