{ pkgs, ... }:
{
  services.mopidy = {
    enable = true;
    extensionPackages = with pkgs; [
      mopidy-iris
      mopidy-jellyfin
      mopidy-mpris
    ];
    settings = {
      audio = {
        mixer = "software";
        mixer_volume = "";
        output = "autoaudiosink";
        buffer_time = "";
      };

      core = {
        max_tracklist_length = 10000;
        restore_state = false;
      };

      http = {
        enabled = true;
        hostname = "0.0.0.0";
        port = 6680;
        csrf_protection = true;
      };

      jellyfin = {
        hostname = "jellyfin.rovacsek.com";
        # TODO: get these into age
        username = "";
        password = "";
        libraries = "Music";
        album_format = "{ProductionYear} - {Name}";
      };
    };
  };
}
