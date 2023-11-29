{ config, ... }: {
  services.deluge = {
    enable = true;

    authFile = config.age.secrets.delugeAuthFile.path;
    config = {
      send_info = false;
      info_sent = 0;
      daemon_port = 58846;
      allow_remote = false;
      pre_allocate_storage = false;
      download_location = "";
      listen_ports = [ 6881 6891 ];
      random_port = true;
      listen_use_sys_port = false;
      listen_reuse_port = true;
      random_outgoing_ports = true;
      copy_torrent_file = false;
      del_copy_torrent_file = false;
      prioritize_first_last_pieces = false;
      sequential_download = false;
      dht = true;
      upnp = true;
      natpmp = true;
      utpex = true;
      lsd = true;
      enc_in_policy = 1;
      enc_out_policy = 1;
      enc_level = 2;
      max_connections_global = 200;
      max_upload_speed = -1.0;
      max_download_speed = -1.0;
      max_upload_slots_global = 4;

      max_connections_per_second = 20;
      ignore_limits_on_local_network = true;
      max_connections_per_torrent = -1;
      max_upload_slots_per_torrent = -1;
      max_upload_speed_per_torrent = -1;
      max_download_speed_per_torrent = -1;
      enabled_plugins = [ ];
      add_paused = false;
      max_active_seeding = 5;
      max_active_downloading = 3;
      max_active_limit = 8;
      dont_count_slow_torrents = false;
      queue_new_to_top = false;
      stop_seed_at_ratio = false;
      remove_seed_at_ratio = false;
      stop_seed_ratio = 2.0;
      share_ratio_limit = 2.0;
      seed_time_ratio_limit = 7.0;
      seed_time_limit = 180;
      auto_managed = true;
      move_completed = false;
      move_completed_paths_list = [ ];
      download_location_paths_list = [ ];
      path_chooser_show_chooser_button_on_localhost = true;
      path_chooser_auto_complete_enabled = true;
      path_chooser_accelerator_string = "Tab";
      path_chooser_max_popup_rows = 20;
      path_chooser_show_hidden_files = false;
      new_release_check = true;
      peer_tos = "0x00";
      rate_limit_ip_overhead = true;
      geoip_db_location = "/usr/share/GeoIP/GeoIP.dat";
      cache_size = 512;
      cache_expiry = 60;
      auto_manage_prefer_seeds = false;
      shared = false;
      super_seeding = false;
    };
    # TODO confirm what this means / config or content?
    # dataDir = "";
    declarative = true;

    # TODO= change before deploy
    # user = "";
    # group = "";

    web = {
      enable = true;
      openFirewall = true;
      port = true;
    };
  };
}
