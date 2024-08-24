{ pkgs, ... }:
let
  # See also: https://github.com/ranger/ranger#optional-dependencies
  packages = with pkgs; [
    atool
    bat
    calibre
    exiftool
    ffmpeg
    imagemagick
    libarchive
    libcaca
    librsvg
    odt2txt
    poppler_utils
    ranger
    unrar
    unzip
    w3m
    zathura
  ];
in
{
  imports = [ ../xdg ];

  home = {
    inherit packages;
  };

  xdg.configFile."ranger/rc.conf".text = ''
    set viewmode miller
    set column_ratios 1,3,4
    set show_hidden true
    set use_preview_script true
    set automatically_count_files true
    set open_all_images true
    set vcs_aware true
    set vcs_backend_git enabled
    set vcs_backend_hg disabled
    set vcs_backend_bzr disabled
    set vcs_backend_svn disabled
    set vcs_msg_length 50
    set preview_images true
    set preview_images_method w3m
    set sixel_dithering FloydSteinberg
    set unicode_ellipsis false
    set bidi_support false
    set show_hidden_bookmarks true
    set preview_files true
    set preview_directories true
    set collapse_preview true
    set wrap_plaintext_previews false
    set save_console_history false
    set status_bar_on_top false
    set draw_progress_bar_in_status_bar true

    # Draw borders around columns? (separators, outline, both, or none)
    # Separators are vertical lines between columns.
    # Outline draws a box around all the columns.
    # Both combines the two.
    set draw_borders outline

    set mouse_enabled false
    set display_size_in_main_column true
    set display_size_in_status_bar true
    set display_free_space_in_status_bar true
    set display_tags_in_all_columns true
    set update_title false
    set tilde_in_titlebar false
    set max_history_size 20
    set max_console_history_size 50
    set scroll_offset 8
    set flushinput true
    set padding_right true
    set sort natural
    set sort_reverse false
    set sort_case_insensitive true
    set sort_directories_first true
    set sort_unicode false
    set preview_max_size 0
    set hint_collapse_threshold 10
    set show_selection_in_titlebar true
    set idle_delay 2000
    set metadata_deep_search false
    set clear_filters_on_dir_change false
    set line_numbers false
    set relative_current_zero false
    set one_indexed false
    set save_tabs_on_exit false
    set filter_dead_tabs_on_startup false
    set wrap_scroll true
    set global_inode_type_filter
    set freeze_files false
    set size_in_bytes false
    set binary_size_prefix false
    set nested_ranger_warning true
  '';
}
