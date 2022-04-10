{ userConfig, ... }:

let
  extraGroupExtendedOptions = if userConfig.name == userConfig.group.name then
    { }
  else {
    "${userConfig.name}" = { };
  };

in {
  extraUsers = {
    "${userConfig.name}" = {
      uid = userConfig.uid;
      isSystemUser = true;
      createHome = false;
      description = "User account generated for running a specific service";
      group = "${userConfig.name}";
      extraGroups = userConfig.extraGroups;
    };
  };

  extraGroups = {
    "${userConfig.group.name}" = {
      gid = userConfig.group.id;
      members = userConfig.group.members;
    };
  } // extraGroupExtendedOptions;
}
