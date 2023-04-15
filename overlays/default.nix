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

  # Useful for SBCs when they will be missing modules that upstream definitions
  # expect but we won't use; e.g SATA
  makeModulesClosure = _final: prev: {
    makeModulesClosure = x:
      prev.makeModulesClosure (x // { allowMissing = true; });
  };

  # https://discourse.nixos.org/t/add-python-package-via-overlay/19783/5
  python310Overlays = final: prev: {
    python310Overlays = (prev.python310Overlays or [ ]) ++ [
      (_python-final: _python-prev: {
        omegaconf = prev.python310Packages.omegaconf.overrideAttrs
          (_old: rec { doInstallCheck = false; });

        pydevd = prev.python310Packages.pydevd.overrideAttrs
          (_old: rec { meta.broken = false; });

        # https://www.youtube.com/watch?v=9IG3zqvUqJY
        tensorflow = prev.python310Packages.tensorflow.overrideAttrs
          (_old: rec { meta.insecure = false; });
      })
    ];

    python3 = let
      self = prev.python3.override {
        inherit self;
        packageOverrides =
          prev.lib.composeManyExtensions final.python310Overlays;
      };
    in self;
    python310Packages = final.python3.pkgs;
  };

  vscodium-wayland = _final: prev: {
    vscodium-wayland =

      let
        waylandFlags =
          "--enable-features=UseOzonePlatform --ozone-platform=wayland";
      in prev.vscodium.overrideAttrs (old: rec {
        runScript =
          "${prev.vscodium}/bin/${old.passthru.executableName} ${waylandFlags}";

        desktopItem = prev.makeDesktopItem {
          name = old.passthru.executableName;
          desktopName = old.passthru.longName;
          comment = "Code Editing. Redefined.";
          genericName = "Text Editor";
          exec = "${old.passthru.executableName} %F ${waylandFlags}";
          icon = "code";
          startupNotify = true;
          startupWMClass = old.pname;
          categories = [ "Utility" "TextEditor" "Development" "IDE" ];
          mimeTypes = [ "text/plain" "inode/directory" ];
          keywords = [ "vscode" ];
          actions.new-empty-window = {
            name = "New Empty Window";
            exec =
              "${old.passthru.executableName} --new-window %F ${waylandFlags}";
            icon = "code";
          };
        };
      });
  };
}
