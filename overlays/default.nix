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

  # https://stackoverflow.com/questions/70395839/how-to-globally-override-a-pythonpackage-in-nix/74550150#74550150
  # With slight tweaks to target versions to avoid needing to think about overrides for all recent versions of 
  # python (though hardcoded below...)
  #
  # Very important note in that response: https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/python.section.md#interpreters-interpreters
  # aka DONT override python3 or python2 as they are just aliases of current version (310 at time of writing.)
  pythonOverlays = let
    pythonVersions =
      [ "python38" "python39" "python310" "python311" "python312" ];
  in _final: prev:
  prev.lib.attrsets.genAttrs pythonVersions (version:
    prev.${version}.override {
      packageOverrides = _python-final: python-prev: {
        omegaconf =
          python-prev.omegaconf.overrideAttrs (_: { doInstallCheck = false; });

        pydevd = python-prev.pydevd.overrideAttrs (_: { meta.broken = false; });
      };
    });

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
