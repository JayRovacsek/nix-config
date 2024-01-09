{ config, lib, pkgs, ... }: {

  home = {
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
          TrayIconAppearance = "monochrome-light";
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

        Security = { IconDownloadFallback = true; };
      };
    packages = with pkgs; [ keepassxc ];
  };
}
