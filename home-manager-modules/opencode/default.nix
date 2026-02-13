{
  pkgs,
  ...
}:
let
  agentsRepo = pkgs.stdenv.mkDerivation {
    name = "agents-repo";
    src = pkgs.fetchFromGitHub {
      owner = "wshobson";
      repo = "agents";
      rev = "cbb60494b1df88ff43bff46821df5e71af6883c7";
      hash = "sha256-2GvwdGRwtICeZntcexjEY3GkrTLG/AMVId2k3NUMtqI=";
    };

    dontBuild = true;
    dontFixup = true;

    nativeBuildInputs = [ pkgs.gnused ];

    postPatch = ''
      find . -type f -exec grep -l "^model: " {} + | xargs sed -i 's/^model: .*$//'
    '';

    installPhase = ''
      mkdir -p $out
      cp -r . $out
    '';
  };
in
{
  programs.opencode = {
    enable = true;
    settings = {
      plugin = [ "opencode-gemini-auth@latest" ];

      mcp.nixos = {
        type = "local";
        command = [
          "nix"
          "run"
          "github:utensils/mcp-nixos"
          "--"
        ];
      };

      lsp.nixd = {
        command = [ "${pkgs.nixd}/bin/nixd" ];
        extensions = [ ".nix" ];
        configuration.nixd = {
          formatting.command = [ "nixfmt" ];
          options.enable = true;
        };
      };
    };
  };

  xdg.configFile = {
    "opencode/agents".source = pkgs.symlinkJoin {
      name = "agents";
      paths = [
        ./agents
        "${agentsRepo}/plugins/business-analytics/agents"
        "${agentsRepo}/plugins/cloud-infrastructure/agents"
        "${agentsRepo}/plugins/code-documentation/agents"
        "${agentsRepo}/plugins/data-engineering/agents"
        "${agentsRepo}/plugins/database-design/agents"
        "${agentsRepo}/plugins/security-scanning/agents"
        "${agentsRepo}/plugins/startup-business-analyst/agents"
        "${agentsRepo}/plugins/systems-programming/agents"
      ];
    };
    "opencode/commands".source = pkgs.symlinkJoin {
      name = "commands";
      paths = [
        "${agentsRepo}/plugins/code-documentation/commands"
        "${agentsRepo}/plugins/data-engineering/commands"
        "${agentsRepo}/plugins/security-scanning/commands"
        "${agentsRepo}/plugins/startup-business-analyst/commands"
        "${agentsRepo}/plugins/systems-programming/commands"

      ];
    };
    "opencode/skills".source = pkgs.symlinkJoin {
      name = "skills";
      paths = [
        ./skills
        "${agentsRepo}/plugins/business-analytics/skills"
        "${agentsRepo}/plugins/cloud-infrastructure/skills"
        "${agentsRepo}/plugins/data-engineering/skills"
        "${agentsRepo}/plugins/database-design/skills"
        "${agentsRepo}/plugins/security-scanning/skills"
        "${agentsRepo}/plugins/startup-business-analyst/skills"
        "${agentsRepo}/plugins/systems-programming/skills"
      ];
    };
  };
}
