_: {
  name = "NotificationOptions";
  props = ''xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"'';

  value = [
    {
      name = "Options";
      value =
        builtins.map
          (x: {
            name = x;
            value = [
              {
                name = "Type";
                value = "TaskFailed";
              }
              { name = "DisabledMonitorUsers"; }
              { name = "SendToUsers"; }
              {
                name = "Enabled";
                value = true;
              }
              { name = "DisabledServices"; }
              {
                name = "SendToUserMode";
                value = "Admins";
              }
            ];
          })
          [
            "TaskFailed"
            "ServerRestartRequired"
            "ApplicationUpdateAvailable"
            "ApplicationUpdateInstalled"
            "PluginUpdateInstalled"
            "PluginUninstalled"
            "InstallationFailed"
            "PluginInstalled"
            "PluginError"
            "UserLockedOut"
            "VideoPlayback"
          ];
    }
  ];
}
