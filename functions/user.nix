{ userConfig, pkgs }: {
  "${userConfig.name}" = {
    isNormalUser = true;
    initialHashedPassword = userConfig.initialHashedPassword;
    extraGroups = userConfig.extraGroups;
    openssh.authorizedKeys.keys = userConfig.openssh.authorizedKeys.keys;
    home = "/home/${userConfig.name}";
    shell = pkgs."${userConfig.shell}";
  };
}
