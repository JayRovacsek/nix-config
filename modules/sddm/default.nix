{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ sddm-chili-theme ];
  services.xserver = {
    enable = true;
    displayManager.sddm = {
      enable = true;
      theme = "chili";
    };
  };
}
