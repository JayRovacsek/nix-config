_: {
  # Required for homebrew on aarch64, TODO: add x86 locations
  environment.systemPath = [
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
  ];

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };

    casks = [
      "keepingyouawake"
      "microsoft-teams"
      "nextcloud"
      "okta-verify"
      "onedrive"
      "zoom"
    ];
  };
}
