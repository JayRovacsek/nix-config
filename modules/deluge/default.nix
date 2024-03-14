{ config, pkgs, self, ... }:
let
  user = "media";
  owner = user;
in {
  age = {
    identityPaths = [ "/agenix/id-ed25519-deluge-primary" ];

    secrets.deluge-auth-file = {
      file = ../../secrets/deluge/auth-file.age;
      mode = "0400";
      owner = config.services.deluge.user;
    };
  };

  services.deluge = {
    enable = true;

    authFile = config.age.secrets.deluge-auth-file.path;
    declarative = true;

    config = {
      add_paused = false;
      allow_remote = false;
      auto_manage_prefer_seeds = false;
      auto_managed = true;
      cache_expiry = 60;
      cache_size = 512;
      copy_torrent_file = false;
      daemon_port = 58846;
      del_copy_torrent_file = false;
      dht = true;
      dont_count_slow_torrents = true;
      enabled_plugins = [ "Extractor" "Label" ];
      enc_in_policy = 1;
      enc_level = 1;
      enc_out_policy = 1;
      geoip_db_location = "${pkgs.geolite-legacy}/share/GeoIP/GeoIP.dat";
      ignore_limits_on_local_network = true;
      info_sent = 0.0;
      listen_ports = [ 6881 6891 ];
      listen_reuse_port = true;
      listen_use_sys_port = false;
      lsd = true;
      max_active_downloading = 25;
      max_active_limit = 50;
      max_active_seeding = 20;
      max_connections_global = 200;
      max_connections_per_second = 40;
      max_connections_per_torrent = -1;
      max_download_speed = 6000.0;
      max_download_speed_per_torrent = -1;
      max_upload_slots_global = 8;
      max_upload_slots_per_torrent = -1;
      max_upload_speed = 250.0;
      max_upload_speed_per_torrent = -1;
      natpmp = false;
      new_release_check = false;
      path_chooser_accelerator_string = "Tab";
      path_chooser_auto_complete_enabled = true;
      path_chooser_max_popup_rows = 20;
      path_chooser_show_chooser_button_on_localhost = true;
      path_chooser_show_hidden_files = true;
      peer_tos = "0x00";
      pre_allocate_storage = false;
      prioritize_first_last_pieces = false;
      queue_new_to_top = true;
      random_outgoing_ports = true;
      random_port = true;
      rate_limit_ip_overhead = true;
      remove_seed_at_ratio = true;
      seed_time_limit = 180;
      seed_time_ratio_limit = 7.0;
      send_info = false;
      sequential_download = false;
      share_ratio_limit = 2.0;
      shared = false;
      stop_seed_at_ratio = true;
      stop_seed_ratio = 2.0;
      super_seeding = false;
      upnp = false;
      utpex = true;
    };

    extraPackages = with pkgs; [ bzip2 gnutar unzip xz ];

    openFirewall = true;

    web = {
      enable = true;
      openFirewall = true;

      inherit (self.common.networking.services.deluge) port;
    };
  };
}
