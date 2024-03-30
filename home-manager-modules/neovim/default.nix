{ config, pkgs, ... }: {
  # Configuration Options
  # https://nix-community.github.io/nixvim/

  home = {
    packages = with pkgs; [ zathura ];
    sessionVariables.EDITOR = "${config.programs.nixvim.package}/bin/nvim";
  };

  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    # Custom Package
    package = pkgs.neovim-unwrapped;

    # Global Options
    options = {
      # Line Numbers
      number = true;
      relativenumber = false;

      # Spellcheck Locale
      spelllang = "en_au";

      shiftwidth = 2;
      tabstop = 2;
      softtabstop = 2;
      expandtab = true;
      autoindent = true;
      fileencoding = "utf-8";
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>mp";
        action = "<Plug>MarkdownPreviewToggle";
      }
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>Telescope find_files<cr>";
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = "<cmd>Telescope live_grep<cr>";
      }
      {
        mode = "n";
        key = "<leader>fb";
        action = "<cmd>Telescope buffers<cr>";
      }
      {
        mode = "n";
        key = "<leader>fh";
        action = "<cmd>Telescope help_tags<cr>";
      }
      {
        mode = "n";
        key = "<c-p>";
        action = "<cmd>Telescope find_files<cr>";
      }
      {
        mode = "n";
        key = "<c-s-p>";
        action = "<cmd>Telescope commands<cr>";
      }
      {
        mode = "n";
        key = "<c-k>";
        action = "<cmd>Telescope buffers<cr>";
      }
      {
        mode = "n";
        key = "<c-s-k>";
        action = "<cmd>Telescope keymaps<cr>";
      }
    ];

    # Plugin Definitions (Modules)
    plugins = {
      bufferline.enable = true;
      # Git Integration
      diffview.enable = true; # https://github.com/sindrets/diffview.nvim
      gitblame.enable = true; # https://github.com/Zorcal/gitblame.nvim
      gitsigns.enable = true; # https://github.com/lewis6991/gitsigns.nvim

      markdown-preview.enable = true;

      neo-tree = {
        enable = true;
        enableDiagnostics = false;
        enableGitStatus = true;
        enableModifiedMarkers = true;
        enableRefreshOnWrite = true;

        popupBorderStyle = "rounded";

        closeIfLastWindow = true;
        extraOptions = { filesystem.filtered_items.visible = true; };
      };

      telescope = {
        enable = true;

        enabledExtensions = [ "ui-select" ];
        extensionConfig.ui-select = { };

        extensions.frecency.enable = true;
        extensions.fzf-native.enable = true;
      };

      # Better highlighting
      treesitter.enable =
        true; # https://github.com/nvim-treesitter/nvim-treesitter

      # Notifications
      notify.enable = true; # https://github.com/rcarriga/nvim-notify

      # Status Line (Bottom Bar)
      lualine.enable = true; # https://github.com/nvim-lualine/lualine.nvim

      # Linting
      lint.enable = true;
      lsp-format.enable = true;

      # Completion
      cmp.enable = true; # https://github.com/hrsh7th/nvim-cmp

      # Language Servers 
      lsp = {
        enable = true;
        servers = {
          bashls.enable = true;
          pylsp.enable = true;
          html.enable = true;
          cssls.enable = true;
          jsonls.enable = true;
          eslint.enable = true;
          nixd.enable = true;
          typst-lsp.enable = true;
          tsserver.enable = true;
          terraformls.enable = true;
          yamlls.enable = true;
        };
      };

      # Language Specific Plugins
      nix.enable = true;
      nix-develop.enable = true;
      typst-vim = {
        enable = true;
        settings.pdf_viewer = "zathura";
      };
    };

    # Plugin Definitions (nixpkgs)
    extraPlugins = with pkgs.vimPlugins; [ nvchad telescope-ui-select-nvim ];
  };
}
