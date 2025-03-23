{ pkgs, ... }:
{
  # Extended options for jellyfin
  imports = [ ../../options/modules/jellyfin ];

  # TODO: add logic to ensure the unit loads _after_ zfs
  # mounts if they exist as they may be utilised.

  # As per: https://wiki.nixos.org/wiki/Jellyfin#Intro_Skipper_plugin
  nixpkgs.overlays = with pkgs; [
    (_: prev: {
      jellyfin-web = prev.jellyfin-web.overrideAttrs (
        _: _: {
          installPhase = ''
            runHook preInstall
            ${gnused}/bin/sed -i "s#</head>#<script src=\"configurationpage?name=skip-intro-button.js\"></script></head>#" dist/index.html
            ${coreutils}/bin/mkdir -p $out/share
            ${coreutils}/bin/cp -a dist $out/share/jellyfin-web
            runHook postInstall
          '';
        }
      );
    })
  ];

  services.jellyfin = {
    enable = true;
    openFirewall = true;
    data-dir = null;
    cache-dir = null;
    metadata-dir = null;
    use-declarative-settings = true;
    user = "media";
    group = "media";
  };
}
