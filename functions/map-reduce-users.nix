{ config, pkgs, userConfigs, ... }: {
  users = builtins.foldl' (x: y: x // y) {
    # There's the obvious huge downside of seeding systems with the same initial root
    # config. But breaking the hash below is going to matter once I no longer do.
    # Please hold up math :)
    root = {
      initialHashedPassword =
        "$6$wRRIfT/GbE4O9sCu$4SVNy.ig6x.qFiefE0y/aG4kdbKEdXF23bew7f53tn.ZxBDKra64obi0CoSnwRJBT1p5NlLEXh5m9jhX6.k3a1";
    };
  } (builtins.map (x: {
    "${x.name}" = rec {
      isNormalUser =
        if builtins.hasAttr "isNormalUser" x then x.isNormalUser else false;
      isSystemUser = !isNormalUser;
      initialHashedPassword = if builtins.hasAttr "initialHashedPassword" x then
        x.initialHashedPassword
      else
        null;
      extraGroups =
        if builtins.hasAttr "extraGroups" x then x.extraGroups else [ ];
      openssh.authorizedKeys.keys = if builtins.hasAttr "openssh" x then
        x.openssh.authorizedKeys.keys
      else
        [ ];
      home = if builtins.hasAttr "home" x then x.home else "/var/empty";
      shell = if builtins.hasAttr "shell" x then x.shell else pkgs.shadow;
      group = if isNormalUser then "users" else x.name;
    };
  }) userConfigs);
}
