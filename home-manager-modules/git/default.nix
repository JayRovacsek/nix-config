{
  config,
  lib,
  pkgs,
  ...
}:
{
  age = {
    identityPaths =
      (lib.optionals pkgs.stdenv.hostPlatform.isLinux [
        "/agenix/id-ed25519-jay-primary"
      ])
      ++ (lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
        "/private/var/agenix/id-ed25519-jay-primary"
      ]);
    # symlink = false installs each secret as a real file at its path rather
    # than a symlink into $XDG_RUNTIME_DIR/agenix; the key material then
    # travels with any mount of ~/.config/git (e.g. the ai-jail sandboxes),
    # where the agenix runtime directory is not present.
    secrets = {
      git-signing-key = {
        file = ../../secrets/git/git-signing-key.age;
        mode = "400";
        path = "${config.xdg.configHome}/git/git-signing-key";
        symlink = false;
      };

      # This doesn't need to be a secret, however the assessment of the public key
      # leads to git checking the same location for a private key. If we don't add
      # this as a secret, it'll exist in a location that is not matching the
      # private key, causing signing failures.
      git-signing-key-pub = {
        file = ../../secrets/git/git-signing-key-pub.age;
        mode = "400";
        path = "${config.xdg.configHome}/git/git-signing-key.pub";
        symlink = false;
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
