{ self, ... }: {
  # Required if we want to pin microvm kernel version, the output version
  # will follow prev.linuxPackages
  alt-microvm-kernel = _final: prev: {
    microvm-kernel = prev.linuxPackages.callPackage
      (self.inputs.microvm + /pkgs/microvm-kernel.nix) { };
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

  grub2 = _final: prev: {
    inherit (self.inputs."grub-2.06".legacyPackages.${prev.system}) grub2;
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

  python = _final: prev:
    prev.lib.attrsets.genAttrs [
      "python38"
      "python39"
      "python310"
      "python311"
      "python312"
    ] (version:
      prev.${version}.override {
        packageOverrides = _: python-prev: {

          pyxattr = python-prev.pyxattr.overrideAttrs (old: rec {
            buildInputs = prev.lib.optional prev.stdenv.isLinux prev.attr;

            meta = prev.lib.recursiveUpdate old.meta {
              platforms = old.meta.platforms
                ++ [ "aarch64-darwin" "x86_64-darwin" ];
            };

            hardeningDisable =
              prev.lib.optionals prev.stdenv.isDarwin [ "strictoverflow" ];
          });
        };
      });

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

  # Credit entirely to https://github.com/NixOS/nixpkgs/pull/275324 for the below -
  # I cannot wait for it to land in unstable so wayland issues around multi-window 
  # spawning are solved.
  vscodium = _final: prev: {
    vscodium = prev.vscodium.overrideAttrs (old:
      let
        inherit (prev.stdenv.hostPlatform) system;

        version = "1.85.1.23348";
        wayland-problematic-vscodium =
          prev.lib.versionOlder old.version version;

        throwSystem = throw "Unsupported system: ${system}";

        plat = {
          x86_64-linux = "linux-x64";
          x86_64-darwin = "darwin-x64";
          aarch64-linux = "linux-arm64";
          aarch64-darwin = "darwin-arm64";
          armv7l-linux = "linux-armhf";
        }.${system} or throwSystem;

        archive_fmt = if prev.stdenv.isDarwin then "zip" else "tar.gz";

        sha256 = {
          x86_64-linux = "1fhvzwhkcqn3bxh92nidhg2bagxbxyg7c8b582wz1msp1l7c27mq";
          x86_64-darwin =
            "1fspzw4zz8z9f91xhaw5h9r82q8anlk9ck3n3sms3vrb2g992xdr";
          aarch64-linux =
            "1hynvczhz946xz9ygrsax1ap3kyw5wm19mn6s9vcdw7wg8imvcyr";
          aarch64-darwin =
            "0kfr8i7z8x4ys2qsabfg78yvk42f0lnaax0l0wdiv94pp0iixijy";
          armv7l-linux = "0vcywp0cqd1rxvb2zf4h3l5sc9rbi88w1v087q12q265c56izzw8";
        }.${system} or throwSystem;

        src = prev.fetchurl {
          url =
            "https://github.com/VSCodium/vscodium/releases/download/${version}/VSCodium-${plat}-${version}.${archive_fmt}";
          inherit sha256;
        };

      in prev.lib.optionalAttrs wayland-problematic-vscodium {
        inherit src version;
      });
  };
}
