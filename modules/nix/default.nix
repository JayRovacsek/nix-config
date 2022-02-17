{ config, pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  extraOptions = ''
    experimental-features = nix-command flakes
  '';
  package = pkgs.nixUnstable;
in {
  nix = if isDarwin then {
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
      user = "jrovacsek";
    };

    inherit package;
    inherit extraOptions;
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

    inherit package;
    inherit extraOptions;
  };
}
