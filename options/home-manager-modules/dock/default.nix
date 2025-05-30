{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.home.dock;
in
{
  options = {
    home = {
      dock = {
        enable = lib.mkEnableOption ''
          Whether to enable dock module
        '';

        entries = lib.mkOption {
          description = ''
            Entries for the Dock
          '';
          type =
            with lib.types;
            listOf (submodule {
              options = {
                path = lib.mkOption {
                  type = str;
                };

                section = lib.mkOption {
                  type = str;
                  default = "apps";
                };

                options = lib.mkOption {
                  type = str;
                  default = "";
                };
              };
            });
        };
      };
    };
  };

  config =
    with lib;
    mkIf (pkgs.stdenv.isDarwin && cfg.enable) (
      let
        normalise = path: if hasSuffix ".app" path then path + "/" else path;

        entryURI =
          path:
          "file://"
          + (builtins.replaceStrings
            [
              " "
              "!"
              ''"''
              "#"
              "$"
              "%"
              "&"
              "'"
              "("
              ")"
            ]
            [
              "%20"
              "%21"
              "%22"
              "%23"
              "%24"
              "%25"
              "%26"
              "%27"
              "%28"
              "%29"
            ]
            (normalise path)
          );

        wantURIs = concatMapStrings (entry: ''
          ${entryURI entry.path}
        '') cfg.entries;

        createEntries = concatMapStrings (entry: ''
          ${pkgs.dockutil-bin}/bin/dockutil --no-restart --add '${entry.path}' --section ${entry.section} ${entry.options} --replacing ${entry.section}
        '') cfg.entries;
      in
      {
        home = {
          activation = {
            updateDockEntries = ''
              echo >&2 "Setting up dock items..."
              haveURIs="$(${pkgs.dockutil}/bin/dockutil --list | ${pkgs.coreutils}/bin/cut -f2)"
              if ! diff -wu <(echo -n "$haveURIs") <(echo -n '${wantURIs}') >&2; then
                echo >&2 "Resetting dock"
                ${pkgs.dockutil}/bin/dockutil --no-restart --remove all
                ${createEntries}
                /usr/bin/killall Dock
              else
                echo >&2 "Dock is how we want it"
              fi
            '';
          };
        };
      }
    );
}
