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

  python = _final: prev:
    prev.lib.attrsets.genAttrs [
      "python38"
      "python39"
      "python310"
      "python311"
      "python312"
    ] (version:
      prev.${version}.override {
        packageOverrides = _python-final: python-prev: {
          anyio = python-prev.anyio.overrideAttrs (old: rec {
            version = "3.7.1";
            src = fetchFromGitHub {
              owner = "agronholm";
              repo = old.pname;
              rev = version;
              hash = "sha256-9/pAcVTzw9v57E5l4d8zNyBJM+QNGEuLKrQ0WUBW5xw=";
            };
          });

          blinker = python-prev.blinker.overrideAttrs (old: rec {
            version = "1.6.2";
            src = fetchPypi {
              inherit version;
              inherit (old) pname;
              hash = "sha256-Sv095m7zqfgGdVn7ehy+VVwX3L4VlxsF0bYlw+er4hM=";
            };
          });

          certifi = python-prev.certifi.overrideAttrs (old: rec {
            version = "2023.7.22";
            src = fetchFromGitHub {
              owner = old.pname;
              repo = "python-certifi";
              rev = "8fb96ed81f71e7097ed11bc4d9b19afd7ea5c909";
              hash = "sha256-V3bptJDNMGXlCMg6GHj792IrjfsG9+F/UpQKxeM0QOc=";
            };
          });

          charset-normalizer = python-prev.charset-normalizer.overrideAttrs
            (_old: rec {
              version = "3.2.0";
              src = fetchFromGitHub {
                owner = "Ousret";
                repo = "charset_normalizer";
                rev = "refs/tags/${version}";
                hash = "sha256-CfL5rlrwJs9453z+1xPUzs1B3OyjFBaU6klzY7gJCzA=";
              };
            });

          dnspython = python-prev.dnspython.overrideAttrs (old: rec {
            version = "2.4.0";
            src = prev.fetchPypi {
              inherit (old) pname;
              inherit version;
              hash = "sha256-dY5pHbtFTVzPThsVShnlKEf3niGkL+8XuWkUSvKaTmw=";
            };
            propagatedBuildInputs = (with python; [ sniffio ]) ++ [ httpcore ];
          });

          email-validator = python-prev.email-validator.overrideAttrs
            (old: rec {
              version = "2.0.0";
              src = prev.fetchFromGitHub {
                owner = "JoshData";
                repo = "python-${old.pname}";
                rev = "refs/tags/v${version}";
                hash = "sha256-o7UREa+IBiFjmqx0p+4XJCcoHQ/R6r2RtoezEcWvgbg=";
              };
            });

          flask-security-too = python-prev.flask-security-too.overrideAttrs
            (_old: rec {
              version = "5.0.2";
              src = prev.fetchPypi {
                pname = "Flask-Security-Too";
                inherit version;
                sha256 = "sha256-Nv7g2l0bPSEcrydFU7d1NHjCCJl8Ykq7hOu6QmHeZcI=";
              };
            });

          flask-sqlalchemy = python-prev.flask-sqlalchemy.overrideAttrs
            (old: rec {
              version = "3.0.5";
              src = prev.fetchPypi {
                pname = "flask_sqlalchemy";
                inherit version;
                hash = "sha256-xXZeWMoUVAG1IQbA9GF4VpJDxdolVWviwjHsxghnxbE=";
              };
              propagatedBuildInputs = old.propagatedBuildInputs
                ++ (with python; [ flit-core ]);
            });

          httpcore = python-prev.httpcore.overrideAttrs (old: rec {
            version = "0.17.3";
            src = prev.fetchFromGitHub {
              owner = "encode";
              repo = old.pname;
              rev = "refs/tags/${version}";
              hash = "sha256-ZNtJnlLNBM6dEk7GBW5yAcAE4+3Q4TISHlBEApiM7IY=";
            };
          });

          importlib-resources = python-prev.importlib-resources.overrideAttrs
            (_old: rec {
              version = "6.0.0";
              src = fetchPypi {
                pname = "importlib_resources";
                inherit version;
                hash = "sha256-TPlIdag2i9iVMadW35qevh8VDg+IUDC0YSN7x/LZBfI=";
              };
            });

          mongoengine = python-prev.mongoengine.overrideAttrs (old: rec {
            version = "0.27.0";
            src = prev.fetchFromGitHub {
              owner = "MongoEngine";
              repo = old.pname;
              rev = "refs/tags/v${version}";
              hash = "sha256-UCd7RpsSNDKh3vgVRYrFYWYVLQuK7WI0n/Moukhq5dM=";
            };
          });

          pydantic = python-prev.pydantic.overrideAttrs (old: rec {
            version = "1.10.11";
            src = prev.fetchFromGitHub {
              owner = old.pname;
              repo = old.pname;
              rev = "refs/tags/v${version}";
              hash = "sha256-WxAM/RG69iBIYpq4EbHadRp5dFiXk4G9bVCaYNrp16s=";
            };

            patches = [ ];
          });

          pymongo = python-prev.pymongo.overrideAttrs (old: rec {
            inherit (old) pname;
            version = "4.4.1";
            src = prev.fetchPypi {
              inherit pname version;
              hash = "sha256-pN+H270DrGNy0k8qgFS03DPeSX1SJ7UOxkn0Nq1XQoQ=";
            };
          });

          sqlalchemy = python-prev.sqlalchemy.overrideAttrs (_old: rec {
            version = "2.0.19";
            src = prev.fetchFromGitHub {
              owner = "sqlalchemy";
              repo = "sqlalchemy";
              rev = "refs/tags/rel_${
                  prev.lib.replaceStrings [ "." ] [ "_" ] version
                }";
              hash = "sha256-97q04wQVtlV2b6VJHxvnQ9ep76T5umn1KI3hXh6a8kU=";
            };
          });

          sqlalchemy-utils = python-prev.sqlalchemy-utils.overrideAttrs
            (_old: rec {
              version = "0.41.1";
              src = fetchPypi {
                inherit version;
                pname = "SQLAlchemy-Utils";
                hash = "sha256-ohgb/wHuuER544Vx0sBxjrUgQvmv2MGU0NAod+hLfXQ=";
              };
            });

          webauthn = python-prev.webauthn.overrideAttrs (old: rec {
            version = "1.9.0";
            src = fetchFromGitHub {
              owner = "duo-labs";
              repo = "py_webauthn";
              rev = "refs/tags/v${version}";
              hash = "sha256-bcAAoaa2E6BzqaiEBOE+AGDSg3P9uqEoiqeT4FBjZcs=";
            };

            propagatedBuildInputs = (builtins.filter (x: x.pname != "pydantic")
              old.propagatedBuildInputs) ++ [ pydantic ];
          });

          urllib3 = python-prev.urllib3.overrideAttrs (old: rec {
            version = "2.0.4";
            src = fetchPypi {
              inherit version;
              inherit (old) pname;
              hash = "sha256-jSL4aq6O9eQQ1PU5/enOayEToAG7TRieCu1wZC1gKxE=";
            };
          });

          werkzeug = python-prev.werkzeug.overrideAttrs (_old: rec {
            version = "2.3.6";
            src = fetchPypi {
              pname = "Werkzeug";
              inherit version;
              hash = "sha256-mMd03y+RsFVQB4iR3uXw6wy3l6Uix1eiRSuc7lsgIzA=";
            };
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

  waybar-hyprland = _final: prev: {
    inherit (self.inputs.hyprland.packages.${prev.system}) waybar-hyprland;
  };
}
