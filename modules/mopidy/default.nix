{ config, pkgs, ... }: {
  services.mopidy = {
    enable = true;
    extensionPackages = with pkgs; [ mopidy-jellyfin ];
  };

  environment.systemPackages = with pkgs; [ mopidy-mopify ];
}
