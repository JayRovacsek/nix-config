{
  config,
  osConfig,
  pkgs,
  ...
}:
let
  hosts = [
    "alakazam.local"
    "bellsprout.local"
    "butterfree.local"
    "diglett.local"
    "ditto.local"
    "dragonite.local"
    "gastly.local"
    "igglybuff.local"
    "jigglypuff.local"
    "machop.local"
    "magikarp.local"
    "mankey.local"
    "meowth.local"
    "mew.local"
    "mr-mime.local"
    "nidoking.local"
    "nidorina.local"
    "nidorino.local"
    "ninetales.local"
    "poliwag.local"
    "porygon.local"
    "slowpoke.local"
    "victreebel.local"
    "wigglytuff.local"
    "zubat.local"
  ];

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
        user = config.home.username;
      };
    }
    // acc
  ) { } hosts;
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
