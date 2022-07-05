{ userConfig }: {
  "${userConfig.name}" = {
    isNormalUser = true;
    initialHashedPassword = userConfig.initialHashedPassword;
    extraGroups = userConfig.extraGroups;
    openssh.authorizedKeys.keys = userConfig.openssh.authorizedKeys.keys;
    home = userConfig.home;
    shell = userConfig.shell;
  };
}
