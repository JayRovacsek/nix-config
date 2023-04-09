{ config, osConfig, lib, ... }:
let
  # Check if signing key is configured as expected
  signingKeyConfigured = builtins.hasAttr "age" osConfig
    && builtins.hasAttr "git-signing-key.pub" osConfig.age.secrets;

  # Cannot use a reference below in a conditional to build our
  # desired config as it causes infinite recursion. We'll just assume
  # a signers file is configured in the standard location to get around
  # this.
  useExtraConfig = signingKeyConfigured;

  # Create a set with signing config present for systems that 
  # can support it
  extraConfig = lib.attrsets.optionalAttrs useExtraConfig {
    commit.gpgsign = true;
    gpg = {
      format = "ssh";
      ssh.allowedSignersFile =
        config.home.file.".ssh/allowed_signers".source.outPath;
    };
    user.signingkey = osConfig.age.secrets."git-signing-key.pub".path;
  };

in {
  programs.git = {
    enable = true;
    difftastic = {
      enable = true;
      background = "dark";
      color = "auto";
    };
    lfs = {
      enable = true;
      skipSmudge = true;
    };
    userEmail = "jay@rovacsek.com";
    userName = "jayrovacsek";

    inherit extraConfig;
  };
}
