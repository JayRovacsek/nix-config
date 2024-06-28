{ self, ... }: {
  # Required if we want to pin microvm kernel version, the output version
  # will follow prev.linuxPackages
  alt-microvm-kernel = _final: prev: {
    microvm-kernel = prev.linuxPackages.callPackage
      (self.inputs.microvm + /pkgs/microvm-kernel.nix) { };
  };

  ags-config = _final: prev: {
    inherit (self.inputs.ags-config.packages.${prev.system}) ags-config;
  };

  element-desktop = _final: prev: {
    element-desktop = prev.element-desktop.overrideAttrs (old:
      let executableName = "element-desktop";
      in {
        desktopItem = prev.makeDesktopItem {
          name = "element-desktop";
          exec = "${executableName} --disable-gpu %u";
          icon = "element";
          desktopName = "Element";
          genericName = "Matrix Client";
          comment = old.meta.description;
          categories = [ "Network" "InstantMessaging" "Chat" ];
          startupWMClass = "Element";
          mimeTypes = [ "x-scheme-handler/element" ];
        };
      });
  };

  fcitx-engines = _final: prev: { fcitx-engines = prev.fcitx5; };

  hello = _final: prev: {
    hello = prev.hello.overrideAttrs (_old: rec {
      pname = "hello";
      version = "9001";

      src = prev.fetchurl {
        url = "mirror://gnu/hello/hello-${version}.tar.gz";
        sha256 = prev.lib.fakeHash;
      };

      doCheck = false;
    });
  };

  hello-unfree = _final: prev: {
    hello-unfree = prev.hello-unfree.overrideAttrs (_old: rec {
      pname = "hello-unfree";
      version = "9002";
    });
  };

  hydra = _final: prev: {
    hydra_unstable = prev.hydra_unstable.overrideAttrs (old: {
      doCheck = false;
      patches = (old.patches or [ ]) ++ [ ./patches/hydra.patch ];
    });
  };

  jellyfin-wayland = _final: prev: {
    jellyfin-media-player-wayland = prev.jellyfin-media-player.overrideAttrs
      (_: {
        autoPatchelfIgnoreMissingDeps = [ "libcuda.so.1" ];

        postPatch = ''
          substituteInPlace resources/meta/com.github.iwalton3.jellyfin-media-player.desktop \
            --replace 'Exec=jellyfinmediaplayer' 'Exec=env QT_QPA_PLATFORM=xcb jellyfinmediaplayer'
        '';
      });
  };

  keepassxc = _final: prev: {
    keepassxc = if prev.stdenv.isDarwin then
      prev.stdenvNoCC.mkDerivation (finalAttrs: {
        pname = "keepassxc";
        version = "2.7.8";

        src = prev.fetchurl {
          url =
            "https://github.com/keepassxreboot/${finalAttrs.pname}/releases/download/${finalAttrs.version}/KeePassXC-${finalAttrs.version}-arm64.dmg";
          hash = "sha256-RZlan+DgkKnURwlVl2hi70lFXqFme4xaygRuICpkv3k=";
        };

        sourceRoot = ".";

        nativeBuildInputs = [ prev.undmg ];

        installPhase = ''
          runHook preInstall
          mkdir -p $out/Applications
          cp -r *.app $out/Applications
          runHook postInstall
        '';

        meta = with prev.lib; {
          description =
            "Smooths scrolling and set mouse scroll directions independently";
          homepage = "http://mos.caldis.me/";
          sourceProvenance = with prev.lib.sourceTypes; [ binaryNativeCode ];
          platforms = platforms.darwin;
        };
      })
    else
      prev.keepassxc;
  };

  # TODO; fold any overlay definitions here into the exposed options
  # space within nix-options to nixd will happily identify those auto-completions
  lib = _final: prev:
    let
      lib-net = (import "${self.inputs.lib-net}/net.nix" {
        inherit (self.inputs.nixpkgs) lib;
      }).lib.net;

      net = builtins.removeAttrs (lib-net [ "types" ]);

    in {
      lib = prev.lib.recursiveUpdate prev.lib {
        inherit net;
        types.net = lib-net.types;
      };
    };

  # Useful for SBCs when they will be missing modules that upstream definitions
  # expect but we won't use; e.g SATA
  makeModulesClosure = _final: prev: {
    makeModulesClosure = x:
      prev.makeModulesClosure (x // { allowMissing = true; });
  };

  moonlight-wayland = _final: prev: {
    moonlight-qt-wayland =

      let waylandFlags = "QT_QPA_PLATFORM=wayland";
      in prev.moonlight-qt.overrideAttrs (old: rec {
        runScript = "${waylandFlags} ${prev.moonlight-qt}/bin/${old.pname}";

        desktopItem = prev.makeDesktopItem {
          name = old.pname;
          desktopName = old.pname;
          comment = "Play your PC games on almost any device";
          genericName = "Game Streaming";
          exec = "${waylandFlags} ${prev.moonlight-qt}/bin/${old.pname}";
          # icon = "code";
          startupNotify = true;
          startupWMClass = old.pname;
          categories = [ "Utility" "Game" ];
          keywords = [ "moonlight" ];
        };
      });
  };

  # See also: https://github.com/BKSalman/nix_config/commit/8d94944af411bfff74edafce18ea1d0ca4789bb9
  mpvpaper = _final: prev: {
    mpvpaper = prev.mpvpaper.overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ [ ./patches/mpvpaper.patch ];
    });
  };

  nix-monitored = _final: prev:
    let
      nix-monitored = self.inputs.nix-monitored.packages.${prev.system}.default;
      nix = nix-monitored;
    in {
      inherit nix-monitored;
      nixos-rebuild = prev.nixos-rebuild.override { inherit nix; };
      nix-direnv = prev.nix-direnv.override { inherit nix; };
    };

  # See also: https://github.com/BKSalman/nix_config/commit/8d94944af411bfff74edafce18ea1d0ca4789bb9
  ranger = _final: prev: {
    ranger = prev.ranger.overrideAttrs (old: {
      # This isn't 1.9.4 - we simply want to indicate we're utilising
      # a latter version than 1.9.3 and not break logic in home-manager-modules
      version = "1.9.4";
      src = prev.fetchFromGitHub {
        owner = "ranger";
        repo = "ranger";
        # https://github.com/ranger/ranger/commit/fe7c3b28067a00b0715399d811437545edb83e71
        rev = "fe7c3b28067a00b0715399d811437545edb83e71";
        sha256 = "sha256-KPCts1MimDQYljoPR4obkbfFT8gH66c542CMG9UW7O0=";
      };
      propagatedBuildInputs = old.propagatedBuildInputs
        ++ (with prev.python-prev; [ pylint ]);
    });
  };

  sonarr = _final: prev: {
    sonarr = prev.sonarr.overrideAttrs (old: {
      installPhase = ''
        runHook preInstall

        mkdir -p $out/{bin,share/sonarr-${old.version}}
        cp -r * $out/share/sonarr-${old.version}/.

        makeWrapper "${prev.dotnet-runtime}/bin/dotnet" $out/bin/NzbDrone \
          --add-flags "$out/share/sonarr-${old.version}/Sonarr.dll" \
          --prefix PATH : ${
            prev.lib.makeBinPath
            [ (prev.ffmpeg.override { withSdl2 = false; }) ]
          } \
          --prefix LD_LIBRARY_PATH : ${
            prev.lib.makeLibraryPath [
              prev.curl
              prev.sqlite
              prev.openssl
              prev.icu
            ]
          }

        runHook postInstall
      '';
    });
  };

  waybar = _final: prev: {
    inherit (self.inputs.nixpkgs.legacyPackages.${prev.system}) waybar;
  };
}
