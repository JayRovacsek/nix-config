{
  config,
  lib,
  pkgs,
  ...
}:
{
  age = {
    identityPaths =
      (lib.optionals pkgs.stdenv.isLinux [ "/agenix/id-ed25519-jay-primary" ])
      ++ (lib.optionals pkgs.stdenv.isDarwin [
        "/private/var/agenix/id-ed25519-jay-primary"
      ]);
    secrets = {
      git-signing-key = {
        file = ../../secrets/git/git-signing-key.age;
        mode = "400";
        path = "${config.xdg.configHome}/git/git-signing-key";
      };

      # This doesn't need to be a secret, however the assessment of the public key
      # leads to git checking the same location for a private key. If we don't add
      # this as a secret, it'll exist in a location that is not matching the
      # private key, causing signing failures.
      git-signing-key-pub = {
        file = ../../secrets/git/git-signing-key-pub.age;
        mode = "400";
        path = "${config.xdg.configHome}/git/git-signing-key.pub";
      };
    };
  };

  programs.git = {
    enable = true;

    settings = {
      commit.gpgsign = true;
      gpg = {
        format = "ssh";
        ssh.allowedSignersFile =
          lib.mkIf (builtins.hasAttr ".config/git/allowed_signers" config.home.file)
            config.home.file.".config/git/allowed_signers".source.outPath;
      };
      push.autoSetupRemote = true;

      user = {
        email = "jay@rovacsek.com";
        name = "jayrovacsek";
        signingkey = config.age.secrets.git-signing-key-pub.path;
      };
    };
  };
}
