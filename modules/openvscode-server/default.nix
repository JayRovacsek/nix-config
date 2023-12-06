{ config, pkgs, ... }:
let
  inherit (config.flake.lib.nginx) generate-domains generate-vhosts;

  service-name = "code";

  domains = generate-domains { inherit config service-name; };

  virtualHosts = generate-vhosts {
    inherit config service-name;
    inherit (config.services.openvscode-server) port;
  };
in {
  # Extended options for nginx & openvscode-server
  imports = [ ../../options/nginx ../../options/openvscode-server ];

  age = {
    identityPaths = [ "/agenix/id-ed25519-openvscode-server-primary" ];

    secrets.openvscode-serverConnectionTokenFile = {
      file = ../../secrets/openvscode-server/connection-token-file.age;
      owner = config.services.openvscode-server.user;
      inherit (config.services.openvscode-server) group;
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ config.services.openvscode-server.port ];
  };

  services = {
    nginx = {
      test = { inherit domains; };
      inherit virtualHosts;
    };

    openvscode-server = {
      connectionTokenFile =
        config.age.secrets.openvscode-serverConnectionTokenFile.path;

      enable = true;

      extensions = with pkgs.vscode-extensions; [
        # Nix
        jnoortheen.nix-ide
        arrterian.nix-env-selector

        # JS/TS
        dbaeumer.vscode-eslint

        # XML
        redhat.vscode-xml

        # YAML
        redhat.vscode-yaml

        # TOML
        tamasfe.even-better-toml

        # Go
        golang.go

        # Terraform
        hashicorp.terraform

        # Latex
        james-yu.latex-workshop

        # Rust
        matklad.rust-analyzer

        # Spellcheck
        streetsidesoftware.code-spell-checker

        # Shell
        timonwong.shellcheck

        # Docker
        ms-azuretools.vscode-docker

        # Theme
        zhuangtongfa.material-theme

        # Icons
        pkief.material-icon-theme

        # Markdown
        yzhang.markdown-all-in-one
      ];
      host = "0.0.0.0";
      # Change default as it collides with default hydra port also
      port = 3001;
      serverDataDir = "/home/openvscode-server/.config/openvscode-server";
      telemetryLevel = "off";
    };
  };
}
