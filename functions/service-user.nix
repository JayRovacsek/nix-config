{ userConfig, ... }: {
  extraUsers = {
    "${userConfig.name}" = {
      uid = userConfig.uid;
      isSystemUser = true;
      createHome = false;
      description = "User account generated for running a specific service";
      group = "${userConfig.name}";
    };
  };

  extraGroups = {
    "${userConfig.group.name}" = {
      gid = userConfig.group.id;
      members = userConfig.group.members;
    };
  };
}
