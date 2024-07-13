{ config, lib, pkgs, ... }: {
  home = {
    packages =
      lib.optionals (!pkgs.zed-editor.meta.broken) (with pkgs; [ zed-editor ]);

    file."${config.xdg.configHome}/zed/settings.json".text = builtins.toJSON {
      active_pane_magnification = 1;
      always_treat_brackets_as_autoclosed = false;
      assistant = {
        button = true;
        default_height = 320;
        default_width = 640;
        dock = "right";
        enabled = true;
        provider = {
          default_model = "gpt-4o";
          name = "openai";
        };
        version = "1";
      };
      auto_install_extensions = { html = true; };
      auto_update = true;
      autosave = "off";
      base_keymap = "VSCode";
      buffer_font_family = "Zed Plex Mono";
      buffer_font_features = { };
      buffer_font_size = 15;
      buffer_font_weight = 400;
      buffer_line_height = "comfortable";
      calls = {
        mute_on_join = false;
        share_on_join = false;
      };
      centered_layout = {
        left_padding = 0.2;
        right_padding = 0.2;
      };
      chat_panel = {
        button = true;
        default_width = 240;
        dock = "right";
      };
      code_actions_on_format = { };
      collaboration_panel = {
        button = true;
        default_width = 240;
        dock = "left";
      };
      completion_documentation_secondary_query_debounce = 300;
      confirm_quit = false;
      current_line_highlight = "all";
      cursor_blink = true;
      dev = { };
      diagnostics.include_warnings = false;
      double_click_in_multibuffer = "select";
      drop_target_size = 0.2;
      enable_language_server = true;
      ensure_final_newline_on_save = true;
      expand_excerpt_lines = 3;
      extend_comment_on_newline = true;
      features.inline_completion_provider = "copilot";
      file_scan_exclusions = [
        "**/.git"
        "**/.svn"
        "**/.hg"
        "**/CVS"
        "**/.DS_Store"
        "**/Thumbs.db"
        "**/.classpath"
        "**/.settings"
      ];
      file_types = {
        JSON = [ "flake.lock" ];
        JSONC = [ "**/.zed/**/*.json" "**/zed/**/*.json" ];
      };
      format_on_save = "on";
      formatter = "auto";
      git = {
        git_gutter = "tracked_files";
        inline_blame.enabled = true;
      };
      gutter = {
        code_actions = true;
        folds = true;
        line_numbers = true;
        runnables = true;
      };
      hard_tabs = false;
      hover_popover_enabled = true;
      indent_guides = {
        active_line_width = 1;
        background_coloring = "disabled";
        coloring = "fixed";
        enabled = true;
        line_width = 1;
      };
      inlay_hints = {
        edit_debounce_ms = 700;
        enabled = false;
        scroll_debounce_ms = 50;
        show_other_hints = true;
        show_parameter_hints = true;
        show_type_hints = true;
      };
      inline_completions.disabled_globs = [ ".env" ];
      journal = {
        hour_format = "hour12";
        path = "~";
      };
      language_servers = [ "..." ];
      languages = {
        Astro = {
          prettier = {
            allowed = true;
            plugins = [ "prettier-plugin-astro" ];
          };
        };
        Blade.prettier.allowed = true;
        C.format_on_save = "off";
        "C++".format_on_save = "off";
        CSS.prettier.allowed = true;
        Elixir = {
          language_servers = [ "elixir-ls" "!next-ls" "!lexical" "..." ];
        };
        Go.code_actions_on_format."source.organizeImports" = true;
        GraphQL.prettier.allowed = true;
        HEEX = {
          language_servers = [ "elixir-ls" "!next-ls" "!lexical" "..." ];
        };
        HTML.prettier.allowed = true;
        JSON.prettier.allowed = true;
        JSONC.prettier.allowed = true;
        Java = {
          prettier = {
            allowed = true;
            plugins = [ "prettier-plugin-java" ];
          };
        };
        JavaScript = {
          language_servers = [ "!typescript-language-server" "vtsls" "..." ];
          prettier.allowed = true;
        };
        Markdown = {
          format_on_save = "off";
          prettier.allowed = true;
        };
        PHP.prettier = {
          allowed = true;
          parser = "php";
          plugins = [ "@prettier/plugin-php" ];
        };
        Ruby.language_servers = [ "solargraph" "!ruby-lsp" ];
        SCSS.prettier.allowed = true;
        SQL.prettier = {
          allowed = true;
          plugins = [ "prettier-plugin-sql" ];
        };
        Svelte.prettier = {
          allowed = true;
          plugins = [ "prettier-plugin-svelte" ];
        };
        TSX = {
          language_servers = [ "!typescript-language-server" "vtsls" "..." ];
          prettier.allowed = true;
        };
        Twig.prettier.allowed = true;
        TypeScript = {
          language_servers = [ "!typescript-language-server" "vtsls" "..." ];
          prettier.allowed = true;
        };
        "Vue.js".prettier.allowed = true;
        XML = {
          prettier = {
            allowed = true;
            plugins = [ "@prettier/plugin-xml" ];
          };
        };
        YAML.prettier.allowed = true;
      };
      line_indicator_format = "long";
      linked_edits = true;
      lsp = { };
      message_editor.auto_replace_emoji_shortcode = true;
      multi_cursor_modifier = "alt";
      nightly = { };
      notification_panel = {
        button = true;
        default_width = 380;
        dock = "right";
      };
      outline_panel = {
        auto_fold_dirs = true;
        auto_reveal_entries = true;
        button = true;
        default_width = 300;
        dock = "left";
        file_icons = true;
        folder_icons = true;
        git_status = true;
        indent_size = 20;
      };
      preferred_line_length = 80;
      prettier = { };
      preview = { };
      preview_tabs = {
        enable_preview_from_code_navigation = false;
        enable_preview_from_file_finder = false;
        enabled = true;
      };
      private_files = [
        "**/.env*"
        "**/*.pem"
        "**/*.key"
        "**/*.cert"
        "**/*.crt"
        "**/secrets.yml"
      ];
      project_panel = {
        auto_fold_dirs = false;
        auto_reveal_entries = true;
        button = true;
        default_width = 240;
        dock = "left";
        file_icons = true;
        folder_icons = true;
        git_status = true;
        indent_size = 20;
        scrollbar.show = "always";
      };
      proxy = null;
      redact_private_values = false;
      relative_line_numbers = false;
      remove_trailing_whitespace_on_save = true;
      restore_on_startup = "last_workspace";
      scroll_beyond_last_line = "one_page";
      scroll_sensitivity = 1;
      scrollbar = {
        cursors = true;
        diagnostics = true;
        git_diff = true;
        search_results = true;
        selected_symbol = true;
        show = "auto";
      };
      seed_search_query_from_cursor = "always";
      server_url = "https://zed.dev";
      show_call_status_icon = true;
      show_completion_documentation = true;
      show_completions_on_input = true;
      show_inline_completions = true;
      show_whitespaces = "selection";
      show_wrap_guides = true;
      soft_wrap = "prefer_line";
      stable = { };
      tab_bar = {
        show = true;
        show_nav_history_buttons = true;
      };
      tab_size = 4;
      tabs = {
        close_position = "right";
        git_status = false;
      };
      task.show_status_indicator = true;
      tasks.variables = { };
      telemetry = {
        diagnostics = true;
        metrics = true;
      };
      terminal = {
        alternate_scroll = "off";
        blinking = "terminal_controlled";
        button = true;
        copy_on_select = false;
        default_height = 320;
        default_width = 640;
        detect_venv = {
          on = {
            activate_script = "default";
            directories = [ ".env" "env" ".venv" "venv" ];
          };
        };
        dock = "bottom";
        env = { };
        line_height = "comfortable";
        option_as_meta = false;
        shell = "system";
        toolbar.title = true;
        working_directory = "current_project_directory";
      };
      theme = {
        dark = "One Dark";
        light = "One Light";
        mode = "system";
      };
      toolbar = {
        breadcrumbs = true;
        quick_actions = true;
        selections_menu = true;
      };
      ui_font_family = "Zed Plex Sans";
      ui_font_features.calt = false;
      ui_font_size = 16;
      ui_font_weight = 400;
      use_auto_surround = true;
      use_autoclose = true;
      use_on_type_format = true;
      vertical_scroll_margin = 3;
      vim = {
        use_multiline_find = false;
        use_smartcase_find = false;
        use_system_clipboard = "always";
      };
      vim_mode = false;
      when_closing_with_no_tabs = "platform_default";
      wrap_guides = [ ];
    };
  };
}
