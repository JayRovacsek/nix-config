# All options can be found in the following appendix:
# https://notashelf.github.io/neovim-flake/options.html
_: {
  home.sessionVariables.EDITOR = "vim";

  programs.neovim-flake = {
    # Everything goes inside the settings braces
    enable = true;
    settings.vim = {

      # Aliases
      viAlias = true;
      vimAlias = true;
      lsp.enable = true;

      # Language Support
      languages = {
        enableTreesitter = true;
        enableFormat = true;
        enableLSP = true;

        nix = {
          enable = true;
          format = {
            enable = true;
            type = "nixpkgs-fmt";
          };
        };
        ts.enable = true;
        markdown = {
          enable = true;
          glow.enable = true; # Markdown previews
        };
      };

      # Cheatsheet
      binds.cheatsheet.enable = true;

      # Autocomplete
      autocomplete = {
        enable = true;
        type = "nvim-cmp"; # change this to plugin of choice
      };

      # Dashboard
      dashboard = {
        dashboard-nvim.enable = false;
        alpha.enable = true;
      };

      # Notification Daemon
      notify.nvim-notify.enable = true;

      # Terminal
      terminal.toggleterm = {
        enable = true;
        lazygit.enable = true;
        enable_winbar = true;
      };

      # Github Integration
      git = {
        enable = true;
        gitsigns = {
          enable = true;
          codeActions = false;
        };
      };

      # Candy
      lsp = {
        formatOnSave = true;
        nvimCodeActionMenu.enable = true;
        trouble.enable = true;
        lspkind.enable = true;
      };

      # Syntax Highlighting
      syntaxHighlighting = true;
      treesitter = {
        enable = true;
        autotagHtml = true;
      };

      # File Searching
      telescope.enable = true;

      # Visuals
      visuals = {
        enable = true;
        nvimWebDevicons.enable = true;
        smoothScroll.enable = true;
        scrollBar.enable = true;
        indentBlankline.useTreesitter.enable = true;
        fidget-nvim.enable = true;
      };

      # Line Numbers
      lineNumberMode = "number";

      # Utilities
      utility = {
        icon-picker.enable = true;
        diffview-nvim.enable = true;
        #colorizer.enable = false;
      };

      # UI
      ui = {
        smartcolumn.enable = false; # Auto hides line length indicator
        noice.enable = true; # Pretty tabs and popups
        modes-nvim.enable = true; # Line decorations
      };

      # Lines
      tabline.nvimBufferline.enable = true;
    };
  };
}
