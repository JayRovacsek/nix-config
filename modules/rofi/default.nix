{ config, pkgs, ... }:
let cfg = config.modules.rofi;
in {

  home-manager.users.jay.programs.rofi = {
    enable = true;
    theme = let inherit (config.lib.formats.rasi) mkLiteral;
    in {
      configuration = {
        font = mkLiteral "Noto Sans 10";
        show-icons = true;
        icon-theme = mkLiteral "Papirus";
        display-drun = mkLiteral "";
        drun-display-format = mkLiteral "{name}";
        disable-history = false;
        sidebar-mode = false;
      };

      window = {
        transparency = mkLiteral "real";
        background-color = mkLiteral "@background";
        text-color = mkLiteral "@foreground";
        border = mkLiteral "0px";
        border-color = mkLiteral "@border";
        border-radius = mkLiteral "0px";
        width = mkLiteral "38%";
        location = mkLiteral "center";
        x-offset = 0;
        y-offset = 0;
      };

      prompt = {
        enabled = true;
        padding = mkLiteral "0.30% 0.75% 0% -0.5%";
        background-color = mkLiteral "@background-alt";
        text-color = mkLiteral "@foreground";
        font = mkLiteral "FantasqueSansMono Nerd Font 10";
      };

      entry = {
        background-color = mkLiteral "@background-alt";
        text-color = mkLiteral "@foreground";
        placeholder-color = mkLiteral "@foreground";
        expand = true;
        horizontal-align = 0;
        placeholder = mkLiteral "Search";
        padding = mkLiteral "-0.15% 0% 0% 0%";
        blink = true;
      };

      inputbar = {
        children = mkLiteral "[ prompt, entry ]";
        background-color = mkLiteral "@background";
        text-color = mkLiteral "@foreground";
        expand = false;
        border = mkLiteral "0.1%";
        border-radius = mkLiteral "4px";
        border-color = mkLiteral "@accent";
        margin = mkLiteral "0% 0% 0% 0%";
        padding = mkLiteral "1%";
      };

      listview = {
        background-color = mkLiteral "@background-alt";
        columns = 6;
        lines = 3;
        spacing = mkLiteral "0%";
        cycle = false;
        dynamic = true;
        layout = mkLiteral "vertical";
      };

      mainbox = {
        background-color = mkLiteral "@background-alt";
        border = mkLiteral "0% 0% 0% 0%";
        border-radius = mkLiteral "0% 0% 0% 0%";
        border-color = mkLiteral "@accent";
        children = mkLiteral "[ inputbar, listview ]";
        spacing = mkLiteral "1%";
        padding = mkLiteral "1% 0.5% 1% 0.5%";
      };

      element = {
        background-color = mkLiteral "@background-alt";
        text-color = mkLiteral "@foreground";
        orientation = mkLiteral "vertical";
        border-radius = mkLiteral "0%";
        padding = mkLiteral "2% 0% 2% 0%";
      };

      element-icon = {
        background-color = mkLiteral "@background-alt";
        text-color = mkLiteral "inherit";
        horizontal-align = mkLiteral "0.5";
        vertical-align = mkLiteral "0.5";
        size = mkLiteral "64px";
        border = mkLiteral "0px";
      };

      element-text = {
        background-color = mkLiteral "@background-alt";
        text-color = mkLiteral "inherit";
        expand = true;
        horizontal-align = mkLiteral "0.5";
        vertical-align = mkLiteral "0.5";
        margin = mkLiteral "0.5% 0.5% -0.5% 0.5%";
      };

      "element selected" = {
        background-color = mkLiteral "@background-bar";
        text-color = mkLiteral "@foreground";
        border = mkLiteral "0.1%";
        border-radius = mkLiteral "4px";
        border-color = mkLiteral "@accent";
      };
    };
    terminal = "${pkgs.alacritty}/bin/alacritty";
    package = pkgs.rofi.override { plugins = [ pkgs.rofi-calc ]; };
  };
}
