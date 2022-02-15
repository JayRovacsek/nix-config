{ config, pkgs, ... }:
let inherit (pkgs.stdenv.hostPlatform) isDarwin;
in {
  nix = if isDarwin then {
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
      user = "jrovacsek";
    };

    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  } else {
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
      sandbox = true;
    };

    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
