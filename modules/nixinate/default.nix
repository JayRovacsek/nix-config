{ config, lib, ... }:
let
  localDomain = if builtins.hasAttr "localDomain" config.networking then
    config.networking.localDomain
  else
    config.networking.domain;
in {
  _module.args.nixinate = {
    buildOn = "local";
    substituteOnTarget = true;
    hermetic = true;
    host = "${config.networking.hostName}${
        lib.optionalString (localDomain != null) ".${localDomain}"
      }";
    # sshUser = builder.users.users.builder.name;
    # TODO: make this a fair bit smarter about the user it applies against
    sshUser = "jay";
  };

}
