{ config, osConfig, ... }:
let
  enable = true;
  enableBashIntegration = config.programs.bash.enable
    && osConfig.programs.bash.enable;
  enableFishIntegration = config.programs.fish.enable
    && osConfig.programs.fish.enable;
  enableZshIntegration = config.programs.zsh.enable
    && osConfig.programs.zsh.enable;
in {
  programs.starship = {
    inherit enable enableBashIntegration enableFishIntegration
      enableZshIntegration;
    settings = {
      add_newline = false;
      directory.read_only = "🔒";
      aws.disabled = true;

      username = {
        show_always = true;
        format = "[$user]($style) on ";
        style_user = "green bold";
        style_root = "red bold";
      };

      hostname = {
        ssh_only = false;
        disabled = false;
      };

      character = {
        success_symbol = "[➜](bold green) ";
        error_symbol = "[✗](bold red) ";
      };

      nix_shell = {
        disabled = false;
        impure_msg = "[impure shell](bold red)";
        pure_msg = "[pure shell](bold green)";
        format = "via [☃️ $state( ($name))](bold blue) ";
      };

      cmd_duration = {
        min_time = 3000;
        format = "took [$duration](bold yellow)";
      };

      time = {
        disabled = false;
        format = "🕙[$time]($style) ";
        time_format = "%T";
        utc_time_offset = "+10";
      };

      command_timeout = 5000;
    };
  };
}
