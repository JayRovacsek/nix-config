{ pkgs, lib, config, ... }: {

  home-manager.users.jay.programs.rofi = {
    enable = true;
    theme = {
      configuration = {
        font = "Noto Sans 10";
        show-icons = true;
        icon-theme = "Papirus";
        display-drun = "";
        drun-display-format = "{name}";
        disable-history = false;
        sidebar-mode = false;
      };

      window = {
        transparency = "real";
        background-color = "@background";
        text-color = "@foreground";
        border = "0px";
        border-color = "@border";
        border-radius = "0px";
        width = "38%";
        location = "center";
        x-offset = 0;
        y-offset = 0;
      };

      prompt = {
        enabled = true;
        padding = "0.30% 0.75% 0% -0.5%";
        background-color = "@background-alt";
        text-color = "@foreground";
        font = "FantasqueSansMono Nerd Font 10";
      };

      entry = {
        background-color = "@background-alt";
        text-color = "@foreground";
        placeholder-color = "@foreground";
        expand = true;
        horizontal-align = 0;
        placeholder = "Search";
        padding = "-0.15% 0% 0% 0%";
        blink = true;
      };

      inputbar = {
        children = "[ prompt, entry ]";
        background-color = "@background";
        text-color = "@foreground";
        expand = false;
        border = "0.1%";
        border-radius = "4px";
        border-color = "@accent";
        margin = "0% 0% 0% 0%";
        padding = "1%";
      };

      listview = {
        background-color = "@background-alt";
        columns = 6;
        lines = 3;
        spacing = "0%";
        cycle = false;
        dynamic = true;
        layout = "vertical";
      };

      mainbox = {
        background-color = "@background-alt";
        border = "0% 0% 0% 0%";
        border-radius = "0% 0% 0% 0%";
        border-color = "@accent";
        children = "[ inputbar, listview ]";
        spacing = "1%";
        padding = "1% 0.5% 1% 0.5%";
      };

      element = {
        background-color = "@background-alt";
        text-color = "@foreground";
        orientation = "vertical";
        border-radius = "0%";
        padding = "2% 0% 2% 0%";
      };

      element-icon = {
        background-color = "@background-alt";
        text-color = "inherit";
        horizontal-align = "0.5";
        vertical-align = "0.5";
        size = "64px";
        border = "0px";
      };

      element-text = {
        background-color = "@background-alt";
        text-color = "inherit";
        expand = true;
        horizontal-align = "0.5";
        vertical-align = "0.5";
        margin = "0.5% 0.5% -0.5% 0.5%";
      };

      "element selected" = {
        background-color = "@background-bar";
        text-color = "@foreground";
        border = "0.1%";
        border-radius = "4px";
        border-color = "@accent";
      };
    };
    terminal = "${pkgs.alacritty}/bin/alacritty";
    package = pkgs.rofi.override { plugins = [ pkgs.rofi-calc ]; };
  };
}
