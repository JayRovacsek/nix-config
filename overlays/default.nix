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

  python = _final: prev:
    prev.lib.genAttrs [
      "python38"
      "python39"
      "python310"
      "python311"
      "python312"
    ] (version:
      prev.${version}.override {
        packageOverrides = python-final: python-prev: {
          anyio = python-prev.anyio.overrideAttrs (old: rec {
            version = "3.7.1";
            src = prev.fetchFromGitHub {
              owner = "agronholm";
              repo = old.pname;
              rev = version;
              hash = "sha256-9/pAcVTzw9v57E5l4d8zNyBJM+QNGEuLKrQ0WUBW5xw=";
            };
          });

          afdko = python-prev.afdko.overrideAttrs (_:
            prev.buildPythonPackage rec {
              pname = "afdko";
              version = "3.9.3";
              format = "pyproject";

              src = prev.fetchPypi {
                inherit pname version;
                sha256 = "sha256-v0fIhf3P5Xjdn5/ryRNj0Q2YHAisMqi5RTmJQabaUO0=";
              };

              nativeBuildInputs = with prev; [
                setuptools-scm
                scikit-build
                cmake
              ];

              buildInputs = with prev; [ antlr4_9.runtime.cpp libxml2.dev ];

              # setup.py will always (re-)execute cmake in buildPhase
              dontConfigure = true;

              propagatedBuildInputs = with prev; [
                booleanoperations
                fonttools
                lxml # fonttools[lxml], defcon[lxml] extra
                fs # fonttools[ufo] extra
                unicodedata2 # fonttools[unicode] extra
                brotlipy # fonttools[woff] extra
                zopfli # fonttools[woff] extra
                fontpens
                brotli
                defcon
                fontmath
                mutatormath
                ufoprocessor
                ufonormalizer
                psautohint
                tqdm
              ];

              # Use system libxml2
              FORCE_SYSTEM_LIBXML2 = true;

              nativeCheckInputs = [ prev.pytestCheckHook ];

              preCheck = ''
                export PATH=$PATH:$out/bin
              '';

              disabledTests = [
                # Disable slow tests, reduces test time ~25 %
                "test_report"
                "test_post_overflow"
                "test_cjk"
                "test_extrapolate"
                "test_filename_without_dir"
                "test_overwrite"
                "test_options"
              ] ++ prev.lib.optionals (prev.stdenv.hostPlatform.isAarch
                || prev.stdenv.hostPlatform.isRiscV) [
                  # unknown reason so far
                  # https://github.com/adobe-type-tools/afdko/issues/1425
                  "test_spec"
                ] ++ prev.lib.optionals prev.stdenv.hostPlatform.isi686
                [ "test_type1mm_inputs" ];

              meta = with prev.lib; {
                changelog =
                  "https://github.com/adobe-type-tools/afdko/blob/${version}/NEWS.md";
                description = "Adobe Font Development Kit for OpenType";
                homepage = "https://adobe-type-tools.github.io/afdko";
                license = licenses.asl20;
                maintainers = [ maintainers.sternenseemann ];
              };
            });

          blinker = python-prev.blinker.overrideAttrs (old: rec {
            version = "1.6.2";
            src = prev.fetchPypi {
              inherit version;
              inherit (old) pname;
              hash = "sha256-Sv095m7zqfgGdVn7ehy+VVwX3L4VlxsF0bYlw+er4hM=";
            };
          });

          certifi = python-prev.certifi.overrideAttrs (old: rec {
            version = "2023.7.22";
            src = prev.fetchFromGitHub {
              owner = old.pname;
              repo = "python-certifi";
              rev = "8fb96ed81f71e7097ed11bc4d9b19afd7ea5c909";
              hash = "sha256-V3bptJDNMGXlCMg6GHj792IrjfsG9+F/UpQKxeM0QOc=";
            };
          });

          charset-normalizer = python-prev.charset-normalizer.overrideAttrs
            (_old: rec {
              version = "3.2.0";
              src = prev.fetchFromGitHub {
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
            propagatedBuildInputs = with python-final; [ sniffio httpcore ];
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

          flask-sqlalchemy = python-prev.flask-sqlalchemy.overrideAttrs
            (old: rec {
              version = "3.0.5";
              src = prev.fetchPypi {
                pname = "flask_sqlalchemy";
                inherit version;
                hash = "sha256-xXZeWMoUVAG1IQbA9GF4VpJDxdolVWviwjHsxghnxbE=";
              };
              propagatedBuildInputs = old.propagatedBuildInputs
                ++ (with python-final; [ flit-core ]);
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
              src = prev.fetchPypi {
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
            version = "4.4.1";
            src = prev.fetchPypi {
              inherit version;
              inherit (old) pname;
              hash = "sha256-pN+H270DrGNy0k8qgFS03DPeSX1SJ7UOxkn0Nq1XQoQ=";
            };
          });

          pytest-xdist = python-prev.pytest-xdist.overrideAttrs (old: rec {
            disabledTests = old.disabledTests ++ [
              "test_remote_collect_skip"
              "test_basic_collect_and_runtests"
              "test_remote_collect_fail"
              "test_runtests_all"
              "test_steal_work"
              "test_steal_empty_queue"
            ];
          });

          pyxattr = python-prev.pyxattr.overrideAttrs (old: rec {
            buildInputs = prev.lib.optionals prev.stdenv.isLinux prev.attr;

            meta = prev.lib.recursiveUpdate old.meta {
              platforms = old.meta.platforms
                ++ [ "aarch64-darwin" "x86_64-darwin" ];
            };

            hardeningDisable =
              prev.lib.optionals prev.stdenv.isDarwin [ "strictoverflow" ];
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
              src = prev.fetchPypi {
                inherit version;
                pname = "SQLAlchemy-Utils";
                hash = "sha256-ohgb/wHuuER544Vx0sBxjrUgQvmv2MGU0NAod+hLfXQ=";
              };
            });

          webauthn = python-prev.webauthn.overrideAttrs (_old: rec {
            version = "1.9.0";
            src = prev.fetchFromGitHub {
              owner = "duo-labs";
              repo = "py_webauthn";
              rev = "refs/tags/v${version}";
              hash = "sha256-bcAAoaa2E6BzqaiEBOE+AGDSg3P9uqEoiqeT4FBjZcs=";
            };

            # propagatedBuildInputs = (builtins.filter (x: x.pname != "pydantic")
            #   old.propagatedBuildInputs) ++ [ pydantic ];
          });

          urllib3 = python-prev.urllib3.overridePythonAttrs (old: rec {
            version = "2.0.4";
            format = "pyproject";
            src = prev.fetchPypi {
              inherit version;
              inherit (old) pname;
              hash = "sha256-jSL4aq6O9eQQ1PU5/enOayEToAG7TRieCu1wZC1gKxE=";
            };
            propagatedBuildInputs = old.propagatedBuildInputs
              ++ (with prev.python3Packages; [ hatchling setuptools ]);
          });

          werkzeug = python-prev.werkzeug.overrideAttrs (_old: rec {
            version = "2.3.6";
            src = prev.fetchPypi {
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

  # The below exist to resolve issues with compiling the aarch32 architectures.
  # The failing checks might be able to be removed individually, but
  # just looking at easiest path here.
  armv6l-fixes = _final: prev:
    let
      aws-sdk-cpp-reduced-apis = {
        # For the aws cpp sdk, we need to reduce the apis included for 32 bit systems
        # as well as remove testing capabilities due to test failures introduced by running
        # on a 32 bit arch.
        aws-sdk-cpp = (prev.aws-sdk-cpp.override {
          apis = [ "s3" ];
          customMemoryManagement = false;
        }).overrideAttrs (old: {
          doCheck = false;
          postPatch = ''
            ${old.postPatch}
            substituteInPlace CMakeLists.txt \
              --replace 'option(ENABLE_TESTING "Flag to enable/disable building unit and integration tests" ON)' \
              'option(ENABLE_TESTING "Flag to enable/disable building unit and integration tests" OFF)' \
              --replace 'option(AUTORUN_UNIT_TESTS "Flag to enable/disable automatically run unit tests after building" ON)' \
              'option(AUTORUN_UNIT_TESTS "Flag to enable/disable automatically run unit tests after building" OFF)'
          '';
        });
      };

      disabled-checks = prev.lib.genAttrs [
        "aws-c-common"
        "boehmgc"
        "dav1d"
        "dejagnu"
        "diffutils"
        "elfutils"
        "fribidi"
        "gnugrep"
        "graphite2"
        "libllvm"
        "libressl"
        "libseccomp"
        "libuv"
        "mdbook"
        "openssh"
        "pcre"
        "pixman"
        "rhash"
        "sourceHighlight"
        "spdlog"
      ] (name: prev.${name}.overrideAttrs (_: { doCheck = false; }));

      disabled-install-checks =
        prev.lib.genAttrs [ "git" "gitMinimal" "tpm2-tss" ] (name:
          prev.${name}.overrideAttrs (_: {
            doInstallCheck = false;
            preInstallCheck = "";
          }));

      d-file-offset-fixes = prev.lib.genAttrs [ "bind" "kbd" ] (name:
        prev.${name}.overrideAttrs (_: {
          cmakeFlags = [ "-D_FILE_OFFSET_BITS=64" ];
          configureFlags = [ "CFLAGS=-D_FILE_OFFSET_BITS=64" ];

          NIX_CFLAGS_COMPILE = "-D_FILE_OFFSET_BITS=64";
        }));

      libllvm-fixes = {
        # For the aws cpp sdk, we need to reduce the apis included for 32 bit systems
        # as well as remove testing capabilities due to test failures introduced by running
        # on a 32 bit arch.
        libllvm = prev.libllvm.overrideAttrs (old: {
          doCheck = false;
          postPatch = ''
            ${old.postPatch}
            substituteInPlace CMakeLists.txt \
              --replace 'option(ENABLE_TESTING "Flag to enable/disable building unit and integration tests" ON)' \
              'option(ENABLE_TESTING "Flag to enable/disable building unit and integration tests" OFF)' \
              --replace 'option(AUTORUN_UNIT_TESTS "Flag to enable/disable automatically run unit tests after building" ON)' \
              'option(AUTORUN_UNIT_TESTS "Flag to enable/disable automatically run unit tests after building" OFF)'

            substituteInPlace unittests/ExecutionEngine/Orc/CMakeLists.txt \
              --replace '  OrcCAPITest.cpp' ""
          '';
        });
      };

      llvm-fixes = let
        llvm = prev.llvmPackages.llvm.overrideAttrs (_: { doCheck = false; });
      in {
        llvmPackages =
          prev.lib.recursiveUpdate prev.llvmPackages { inherit llvm; };
      };

      meson-fixes = {
        meson = prev.meson.overrideAttrs (_: {
          checkPhase = prev.lib.concatStringsSep "\n" ([
            "runHook preCheck"
            ''
              patchShebangs 'test cases'
              substituteInPlace \
                'test cases/native/8 external program shebang parsing/script.int.in' \
                  --replace /usr/bin/env ${prev.coreutils}/bin/env
            ''
          ]
          # Remove all tests
            ++ (builtins.map (f: ''rm -vr "${f}";'') [
              "test cases vcstag"
              "test cases"
            ]) ++ [
              ''HOME="$TMPDIR" python ./run_project_tests.py''
              "runHook postCheck"
            ]);
        });
      };

      python-fixes = prev.lib.genAttrs [
        "python38"
        "python39"
        "python310"
        "python311"
        "python312"
      ] (version:
        prev.${version}.override {
          packageOverrides = _: python-prev: {
            psutil = python-prev.psutil.overrideAttrs (old: {
              disabledTests = old.disabledTests
                ++ [ "test_net_if_addrs" "test_net_if_stats" ];
            });

            sphinx = python-prev.psutil.overrideAttrs (old: {
              disabledTests = old.disabledTests
                ++ [ "test_connect_to_selfsigned_with_requests_env_var" "test_net_if_addrs" "test_net_if_stats" ];
            });
          };
        });

      tpm2-tss-extra-deps = {
        tpm2-tss = prev.tpm2-tss.overrideAttrs (old: {
          nativeBuildInputs = old.nativeBuildInputs ++ [ prev.iproute2 ];
        });
      };

    in aws-sdk-cpp-reduced-apis // d-file-offset-fixes // disabled-checks
    // disabled-install-checks // libllvm-fixes // llvm-fixes // meson-fixes
    // python-fixes // tpm2-tss-extra-deps;

  armv7l-fixes = self.overlays.armv6l-fixes;

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
