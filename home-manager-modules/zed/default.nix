{
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  inherit (self.common.colour-schemes.tomorrow-night-blue-base16)
    base00
    base01
    base02
    base03
    base05
    base06
    base08
    base0A
    base0B
    base0F
    scheme
    author
    slug
    ;
in
{
  home = {
    packages = lib.optionals (!pkgs.zed-editor.meta.broken) (
      with pkgs; [ zed-editor ]
    );

    file = {

      "${config.xdg.configHome}/zed/themes/${slug}.json".text = builtins.toJSON {
        "$schema" = "https://zed.dev/schema/themes/v0.1.0.json";
        inherit author;
        name = scheme;
        themes = [
          {
            appearance = "dark";
            name = scheme;
            style = {
              background = "#${base00}";
              border = "#${base01}";
              "border.disabled" = "#${base01}";
              "border.focused" = "#${base0A}";
              "border.selected" = "#${base0A}";
              "border.variant" = "#${base0A}";
              conflict = "#${base08}";
              "conflict.background" = "#${base01}";
              "conflict.border" = "#${base0A}";
              created = "#${base0B}";
              "created.background" = "#${base01}";
              "created.border" = "#${base0A}";
              deleted = "#${base08}";
              "deleted.background" = "#${base0A}";
              "deleted.border" = "#${base01}";
              "drop_target.background" = "#${base02}";
              "editor.active_line.background" = "#${base02}";
              "editor.active_line_number" = "#${base05}";
              "editor.active_wrap_guide" = null;
              "editor.background" = "#${base00}";
              "editor.document_highlight.read_background" = null;
              "editor.document_highlight.write_background" = null;
              "editor.foreground" = "#${base05}";
              "editor.gutter.background" = "#${base01}";
              "editor.highlighted_line.background" = "#${base05}";
              "editor.invisible" = "#${base06}";
              "editor.line_number" = "#${base03}";
              "editor.subheader.background" = null;
              "editor.wrap_guide" = null;
              "element.active" = null;
              "element.background" = null;
              "element.disabled" = null;
              "element.hover" = null;
              "element.selected" = null;
              "elevated_surface.background" = "#${base00}";
              error = "#${base08}";
              "error.background" = null;
              "error.border" = null;
              "ghost_element.active" = null;
              "ghost_element.background" = null;
              "ghost_element.disabled" = null;
              "ghost_element.hover" = null;
              "ghost_element.selected" = null;
              hidden = null;
              "hidden.background" = null;
              "hidden.border" = null;
              hint = null;
              "hint.background" = null;
              "hint.border" = null;
              icon = null;
              "icon.accent" = null;
              "icon.disabled" = null;
              "icon.muted" = null;
              "icon.placeholder" = null;
              ignored = null;
              "ignored.background" = null;
              "ignored.border" = null;
              info = null;
              "info.background" = null;
              "info.border" = null;
              "link_text.hover" = null;
              modified = "#${base0A}";
              "modified.background" = null;
              "modified.border" = null;
              "pane.focused_border" = null;
              "panel.background" = "#${base01}";
              "panel.focused_border" = null;
              predictive = null;
              "predictive.background" = null;
              "predictive.border" = null;
              renamed = "#${base0A}";
              "renamed.background" = null;
              "renamed.border" = null;
              "scrollbar.thumb.border" = null;
              "scrollbar.thumb.hover_background" = null;
              "scrollbar.track.background" = null;
              "scrollbar.track.border" = null;
              "scrollbar_thumb.background" = null;
              "search.match_background" = "#${base0F}";
              "status_bar.background" = "#${base00}";
              success = null;
              "success.background" = null;
              "success.border" = null;
              "surface.background" = null;
              "tab.active_background" = "#${base02}";
              "tab.inactive_background" = "#${base00}";
              "tab_bar.background" = "#${base01}";
              "terminal.ansi.black" = null;
              "terminal.ansi.blue" = null;
              "terminal.ansi.bright_black" = null;
              "terminal.ansi.bright_blue" = null;
              "terminal.ansi.bright_cyan" = null;
              "terminal.ansi.bright_green" = null;
              "terminal.ansi.bright_magenta" = null;
              "terminal.ansi.bright_red" = null;
              "terminal.ansi.bright_white" = null;
              "terminal.ansi.bright_yellow" = null;
              "terminal.ansi.cyan" = null;
              "terminal.ansi.dim_black" = null;
              "terminal.ansi.dim_blue" = null;
              "terminal.ansi.dim_cyan" = null;
              "terminal.ansi.dim_green" = null;
              "terminal.ansi.dim_magenta" = null;
              "terminal.ansi.dim_red" = null;
              "terminal.ansi.dim_white" = null;
              "terminal.ansi.dim_yellow" = null;
              "terminal.ansi.green" = null;
              "terminal.ansi.magenta" = null;
              "terminal.ansi.red" = null;
              "terminal.ansi.white" = null;
              "terminal.ansi.yellow" = null;
              "terminal.background" = "#${base00}";
              "terminal.bright_foreground" = null;
              "terminal.dim_foreground" = null;
              "terminal.foreground" = null;
              text = null;
              "text.accent" = null;
              "text.disabled" = null;
              "text.muted" = null;
              "text.placeholder" = null;
              "title_bar.background" = "#${base00}";
              "toolbar.background" = "#${base02}";
              unreachable = null;
              "unreachable.background" = null;
              "unreachable.border" = null;
              warning = null;
              "warning.background" = null;
              "warning.border" = null;
            };
          }
        ];
      };

      "${config.xdg.configHome}/zed/settings.json".text = builtins.toJSON {
        active_pane_magnification = 1;
        always_treat_brackets_as_autoclosed = false;
        assistant = {
          button = false;
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
        auto_install_extensions = {
          nix = true;
        };
        auto_update = false;
        autosave = "off";
        base_keymap = "VSCode";
        buffer_font_family = "Hack Nerd Font Mono";
        buffer_font_features = { };
        buffer_font_size = 12;
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
          button = false;
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
        double_click_in_multibuffer = "select";
        drop_target_size = 0.2;
        enable_language_server = true;
        ensure_final_newline_on_save = true;
        expand_excerpt_lines = 3;
        extend_comment_on_newline = true;
        features = {
          copilot = false;
          inline_completion_provider = "";
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
          JSONC = [
            "**/.zed/**/*.json"
            "**/zed/**/*.json"
          ];
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
          background_coloring = "enabled";
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
        inline_completions = {
          disabled_globs = [ ".env" ];
        };
        journal = {
          hour_format = "hour12";
          path = "~";
        };
        language_servers = [ "${pkgs.nixd}/bin/nixd" ];
        languages = {
          GraphQL = {
            prettier = {
              allowed = true;
            };
          };
          HTML = {
            prettier = {
              allowed = true;
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
            formatter = {
              external = {
                arguments = [ ];
                command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
              };
            };
          };
          SQL = {
            prettier = {
              allowed = true;
              plugins = [ "prettier-plugin-sql" ];
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
        lsp = { };
        message_editor = {
          auto_replace_emoji_shortcode = true;
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
          alternate_scroll = "off";
          blinking = "terminal_controlled";
          button = false;
          copy_on_select = false;
          default_height = 320;
          default_width = 640;
          detect_venv = {
            on = {
              activate_script = "default";
              directories = [
                ".env"
                "env"
                ".venv"
                "venv"
              ];
            };
          };
          dock = "bottom";
          line_height = "comfortable";
          option_as_meta = false;
          shell = "system";
          toolbar = {
            title = true;
          };
          working_directory = "current_project_directory";
        };
        theme = {
          dark = scheme;
          light = scheme;
          mode = "system";
        };
        toolbar = {
          breadcrumbs = true;
          quick_actions = true;
          selections_menu = true;
        };
        ui_font_family = "Hack Nerd Font Mono";
        ui_font_features = {
          calt = true;
        };
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
  };
}
