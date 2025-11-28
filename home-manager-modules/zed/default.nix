{
  lib,
  pkgs,
  self,
  ...
}:
let
  inherit (pkgs) system;

  required_packages =
    (with pkgs; [
      dockerfile-language-server
      nix
      nixd
      nil
      mdl
      tofu-ls
    ])
    ++ (with self.packages.${system}; [ cst-lsp ]);
in
{
  home.packages = required_packages;

  programs.zed-editor = {
    enable = true;

    extraPackages = required_packages;

    extensions = [
      "codeowners"
      "cspell"
      "csv"
      "dockerfile"
      "editorconfig"
      "github-actions"
      "gitignore-templates"
      "graphql"
      "markdownlint"
      "mermaid"
      "opentofu"
      "python-refactoring"
      "python-requirements"
      "sql"
      "tree-sitter-query"
      "typos"
    ];

    userSettings = {
      node = {
        ignore_system_version = true;
        path = "${pkgs.nodejs_24}/bin/node";
        npm_path = "${pkgs.nodejs_24}/bin/npm";
      };

      active_pane_magnification = 1;
      agent = {
        always_allow_tool_actions = false;
        button = false;
        default_height = 320;
        default_width = 640;
        dock = "right";
        enable_feedback = true;
        enabled = true;
        provider = {
          default_model = "gpt-4o";
          name = "openai";
        };
        single_file_review = true;
      };
      always_treat_brackets_as_autoclosed = false;
      auto_update = false;
      autosave = "off";
      base_keymap = "VSCode";
      buffer_font_features = { };
      buffer_font_size = lib.mkForce 12.0;
      buffer_font_weight = 400;
      buffer_line_height = "comfortable";
      calls = {
        mute_on_join = true;
        share_on_join = false;
      };
      centered_layout = {
        left_padding = 0.2;
        right_padding = 0.2;
      };
      chat_panel = {
        button = "never";
        default_width = 240;
        dock = "right";
      };
      code_actions_on_format = { };
      collaboration_panel = {
        button = false;
        default_width = 240;
        dock = "left";
      };
      completion_documentation_secondary_query_debounce = 300;
      confirm_quit = false;
      current_line_highlight = "all";
      cursor_blink = true;
      diagnostics = {
        include_warnings = true;
      };
      disable_ai = false;
      double_click_in_multibuffer = "select";
      drop_target_size = 0.2;
      edit_predictions = {
        disabled_globs = [ ".env" ];
        enabled_in_text_threads = true;
      };
      enable_language_server = true;
      ensure_final_newline_on_save = true;
      expand_excerpt_lines = 3;
      extend_comment_on_newline = true;
      features = {
        copilot = false;
        edit_prediction_provider = "zed";
      };
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
        Nix = [ "*.nix" ];
        JSONC = [
          "**/.zed/**/*.json"
          "**/zed/**/*.json"
        ];
        OpenTofu = [ "tf" ];
        "OpenTofu Vars" = [ "tfvars" ];
      };
      format_on_save = "on";
      formatter = "auto";
      git = {
        git_gutter = "tracked_files";
        inline_blame = {
          enabled = true;
        };
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
        background_coloring = "indent_aware";
        coloring = "fixed";
        enabled = true;
        line_width = 1;
      };
      inlay_hints = {
        edit_debounce_ms = 700;
        enabled = true;
        scroll_debounce_ms = 50;
        show_other_hints = true;
        show_parameter_hints = true;
        show_type_hints = true;
      };
      journal = {
        hour_format = "hour12";
        path = "~";
      };
      language_servers = [
        "${pkgs.nixd}/bin/nixd"
        "${self.packages.${system}.cst-lsp}/bin/cst_lsp"
      ];
      languages = {
        GraphQL = {
          prettier = {
            allowed = true;
          };
        };
        HTML = {
          formatter = {
            external = {
              arguments = [
                "--stdin-filepath"
                "{buffer_path}"
              ];
              command = "${pkgs.nodePackages.prettier}/bin/prettier";
            };
          };
        };
        JSON = {
          prettier = {
            allowed = true;
          };
        };
        JSONC = {
          prettier = {
            allowed = true;
          };
        };
        JavaScript = {
          formatter = {
            external = {
              arguments = [
                "--stdin-filepath"
                "{buffer_path}"
              ];
              command = "${pkgs.nodePackages.prettier}/bin/prettier";
            };
          };
          language_servers = [
            "!typescript-language-server"
            "vtsls"
          ];
          prettier = {
            allowed = true;
          };
        };
        Markdown = {
          format_on_save = "on";
          prettier = {
            allowed = true;
          };
        };
        Nix = {
          format_on_save = "on";
          language_servers = [
            "nil_lsp"
            "nixd_lsp"
          ];
          formatter = {
            external = {
              arguments = [ ];
              command = "${pkgs.nixfmt}/bin/nixfmt";
            };
          };
        };
        Python = {
          language_servers = [
            "pyright"
            "python-refactoring"
          ];
        };
        SQL = {
          format_on_save = "on";
          formatter = {
            external = {
              arguments = [
                "format"
                "--dialect"
                "snowflake"
                "{buffer_path}"
              ];
              command = "${pkgs.sqlfluff}/bin/sqlfluff";
            };
          };
        };
        "Shell Script" = {
          format_on_save = "on";
          formatter = {
            external = {
              arguments = [
                "--filename"
                "{buffer_path}"
                "--indent"
                "2"
              ];
              command = "${pkgs.shfmt}/bin/shfmt";
            };
          };
        };
        TSX = {
          language_servers = [
            "!typescript-language-server"
            "vtsls"
          ];
          prettier = {
            allowed = true;
          };
        };
        TypeScript = {
          language_servers = [
            "!typescript-language-server"
            "vtsls"
          ];
          prettier = {
            allowed = true;
          };
        };
        XML = {
          prettier = {
            allowed = true;
            plugins = [ "@prettier/plugin-xml" ];
          };
        };
        YAML = {
          prettier = {
            allowed = true;
          };
        };
      };
      line_indicator_format = "long";
      linked_edits = true;
      lsp = {
        nil_lsp.binary = {
          path = "${pkgs.nil}/bin/nil";
          arguments = [ ];
        };

        python-refactoring.binary = {
          path = "${self.packages.${system}.cst-lsp}/bin/cst_lsp";
          arguments = [ ];
        };

        nixd_lsp.binary = {
          path = "${pkgs.nixd}/bin/nixd";
          arguments = [ ];
        };
      };
      message_editor = {
        auto_replace_emoji_shortcode = true;
      };
      minimap = {
        current_line_highlight = "none";
        max_width_columns = 80;
        show = "auto";
        thumb = "hover";
      };
      multi_cursor_modifier = "alt";
      notification_panel = {
        button = false;
        default_width = 380;
        dock = "right";
      };
      outline_panel = {
        auto_fold_dirs = true;
        auto_reveal_entries = true;
        button = false;
        default_width = 300;
        dock = "left";
        file_icons = true;
        folder_icons = true;
        git_status = true;
        indent_size = 20;
      };
      preferred_line_length = 80;
      preview_tabs = {
        enable_preview_from_code_navigation = true;
        enable_preview_from_file_finder = true;
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
        scrollbar = {
          show = "always";
        };
      };
      redact_private_values = true;
      relative_line_numbers = "disabled";
      remove_trailing_whitespace_on_save = true;
      restore_on_startup = "last_workspace";
      scroll_beyond_last_line = "one_page";
      scroll_sensitivity = 1;
      scrollbar = {
        cursors = true;
        diagnostics = "all";
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
      show_edit_predictions = true;
      show_whitespaces = "selection";
      show_wrap_guides = true;
      soft_wrap = "editor_width";
      tab_bar = {
        show = true;
        show_nav_history_buttons = true;
      };
      tab_size = 4;
      tabs = {
        close_position = "right";
        git_status = true;
      };
      task = {
        show_status_indicator = true;
      };
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      terminal = {
        font_family = "Hack Nerd Font Mono";
      };
      theme = "Base16 Tomorrow Night Blue";
      toolbar = {
        breadcrumbs = true;
        quick_actions = true;
        selections_menu = true;
      };
      ui_font_family = "DejaVu Sans";
      ui_font_features = {
        calt = true;
      };
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
