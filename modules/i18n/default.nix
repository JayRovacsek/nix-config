_: {
  i18n = {
    defaultLocale = "en_AU.UTF-8";
    # Install en_GB.UTF-8 as a fallback so programs that inherit a stray
    # LANG=en_GB.UTF-8 from the environment do not fail to set their locale.
    extraLocales = [ "en_GB.UTF-8" ];
    extraLocaleSettings = {
      LC_ADDRESS = "en_AU.UTF-8";
      LC_IDENTIFICATION = "en_AU.UTF-8";
      LC_MEASUREMENT = "en_AU.UTF-8";
      LC_MONETARY = "en_AU.UTF-8";
      LC_NAME = "en_AU.UTF-8";
      LC_NUMERIC = "en_AU.UTF-8";
      LC_PAPER = "en_AU.UTF-8";
      LC_TELEPHONE = "en_AU.UTF-8";
      LC_TIME = "en_AU.UTF-8";
    };
  };
}
