_: {
  programs.thunderbird = {
    enable = true;
    profiles."gx3vop3t" = {
      isDefault = true;
      settings = {
        "calendar.alarms.playsound" = false;
        "calendar.alarms.show" = false;
        "calendar.alarms.showmissed" = false;
      };
    };
    settings = {
      "general.useragent.override" = "";
      "privacy.donottrackheader.enabled" = true;
    };
  };
}
