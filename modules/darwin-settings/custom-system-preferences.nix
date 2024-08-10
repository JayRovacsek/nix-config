{ pkgs, ... }:
{
  system.defaults.CustomSystemPreferences = {
    # "com.apple.finder" = {
    #   ShowExternalHardDrivesOnDesktop = true;
    #   ShowHardDrivesOnDesktop = true;
    #   ShowMountedServersOnDesktop = true;
    #   ShowRemovableMediaOnDesktop = true;
    #   _FXSortFoldersFirst = true;
    #   # When performing a search, search the current folder by default
    #   FXDefaultSearchScope = "SCcf";
    # };
    # "com.apple.desktopservices" = {
    #   # Avoid creating .DS_Store files on network or USB volumes
    #   DSDontWriteNetworkStores = true;
    #   DSDontWriteUSBStores = true;
    # };
    "com.apple.desktop" = {
      override-picture-path = "${pkgs.fetchurl {
        url = "https://openclipart.org/image/2000px/311101";
        sha256 = "sha256-mIMXYOENVSgH0PjhO02MM7beg9AT44uVDj/tXxilDx0=";
      }}";
    };

    # "com.apple.SoftwareUpdate" = {

    # };
  };
}
