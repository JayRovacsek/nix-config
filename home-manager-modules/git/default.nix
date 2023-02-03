{ config, pkgs, osConfig, ... }: {
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

    extraConfig = {
      commit.gpgsign = true;
      gpg = {
        format = "ssh";
        ssh.allowedSignersFile = config.home.file.".ssh/allowed_signers".text;
      };
      user.signingkey = osConfig.age.secrets."git-signing-key.pub".path;
    };
  };
}
