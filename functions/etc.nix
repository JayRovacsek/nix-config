{ config, ... }: {
  "${config.name}" = {
    text = config.text;
    uid = config.uid;
    gid = config.gid;
    mode = config.mode;
  };
}
