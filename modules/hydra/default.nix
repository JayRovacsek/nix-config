{ pkgs, ... }: {
  services.hydra = {
    enable = true;
    extraConfig = "";
    hydraURL = "https://hydra.rovacsek.com";
    listenHost = "*";
    minimumDiskFree = 25;
    minimumDiskFreeEvaluator = 50;
    notificationSender = "";
    package = pkgs.hydra_unstable;
    port = 3000;
    smtpHost = null;
    tracker = "";
    useSubstitutes = true;
  };
}
