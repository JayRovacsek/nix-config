{
  config,
  lib,
  osConfig,
  pkgs,
  self,
  ...
}:
let
  inherit (self.common.config) hosts;

  # For all hosts defined in the common.config attributes; take their
  # fqdn and create an entry for them in our ssh config
  targets = builtins.foldl' (
    acc: x: acc ++ (builtins.foldl' (a: y: a ++ [ y.fqdn ]) [ ] x.ips)
  ) [ ] (builtins.attrValues hosts);

  identityFile = with osConfig.age.secrets; [
    type-a-1.path
    type-a-2.path
    type-c-1.path
    type-c-2.path
  ];

  host-configs = builtins.foldl' (
    acc: x:
    {
      ${x} = {
        extraOptions = {
          AddKeysToAgent = "yes";
          ConnectTimeout = "3";
        };

        forwardAgent = true;
        identitiesOnly = true;
        hostname = x;
        inherit identityFile;

        setEnv = lib.optionalAttrs config.programs.ghostty.enable {
          TERM = "xterm-256color";
        };
        user = config.home.username;
      };
    }
    // acc
  ) { } targets;
in
{
  programs.ssh = {
    enable = true;

    matchBlocks = host-configs // {
      "github.com" = {
        inherit identityFile;
        user = "git";
      };
    };

    package = pkgs.openssh;
  };
}
