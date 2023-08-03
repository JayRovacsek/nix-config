# All options can be found in the following appendix:
# https://notashelf.github.io/neovim-flake/options.html
_: {
  home.sessionVariables.EDITOR = "vim";

  programs.neovim-flake = {
    # Everything goes inside the settings braces
    enable = true;
    settings = {

      # Aliases
      vim.viAlias = true;
      vim.vimAlias = true;
      vim.lsp = { enable = true; };

      # Language Support
      vim.languages = {
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
      vim.binds.cheatsheet.enable = true;

      # Autocomplete
      vim.autocomplete = {
        enable = true;
        type = "nvim-cmp"; # change this to plugin of choice
      };

      # Dashboard
      vim.dashboard = {
        dashboard-nvim.enable = false;
        alpha.enable = true;
      };

      # Notification Daemon
      vim.notify = { nvim-notify.enable = true; };

      # Terminal
      vim.terminal.toggleterm = {
        enable = true;
        lazygit.enable = true;
        enable_winbar = true;
      };

      # Github Integration
      vim.git = {
        enable = true;
        gitsigns.enable = true;
        gitsigns.codeActions = false;
      };

      # Candy
      vim.lsp = {
        formatOnSave = true;
        nvimCodeActionMenu.enable = true;
        trouble.enable = true;
        lspkind.enable = true;
      };

      # Themes
      vim.theme = {
        enable = true;
        name = "tokyonight";
        style = "night";
        transparent = true;
      };

      # File Tree Sidebar
      vim.filetree.nvimTreeLua = {
        enable = true;
        actions = { changeDir.global = true; };
      };

      # Syntax Highlighting
      vim.syntaxHighlighting = true;
      vim.treesitter = {
        enable = true;
        autotagHtml = true;
      };

      # File Searching
      vim.telescope.enable = true;

      # Visuals
      vim.visuals = {
        enable = true;
        nvimWebDevicons.enable = true;
        smoothScroll.enable = true;
        scrollBar.enable = true;
        indentBlankline.useTreesitter.enable = true;
        fidget-nvim.enable = true;
      };

      # Line Numbers
      vim.lineNumberMode = "number";

      # Utilities
      vim.utility = {
        icon-picker.enable = true;
        diffview-nvim.enable = true;
        #colorizer.enable = false;
      };

      # UI
      vim.ui = {
        smartcolumn.enable = false; # Auto hides line length indicator
        noice.enable = true; # Pretty tabs and popups
        modes-nvim.enable = true; # Line decorations
      };

      # Lines
      vim.tabline = { nvimBufferline.enable = true; };
      vim.statusline = {
        lualine = {
          enable = true;
          theme = "tokyonight";
        };
      };

      # Obsidian Integration
      vim.notes.obsidian.enable = true;
    };
  };
}
