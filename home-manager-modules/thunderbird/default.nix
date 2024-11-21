_: {
  programs.thunderbird = {
    enable = true;
    profiles.jay = {
      isDefault = true;
      settings = { };
    };
    settings = {
      "general.useragent.override" = "";
      "privacy.donottrackheader.enabled" = true;
    };
  };
}
