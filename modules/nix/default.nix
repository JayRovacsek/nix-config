{ config, pkgs, ... }: {
  nix = {
    gc = {
      automatic = true;
      dates = "monthly";
      options = "--delete-older-than 7d";
    };
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
    settings = {
      trusted-users = [ "jay" "root" ];
      auto-optimise-store = true;
      useSandbox = true;
    };

    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
