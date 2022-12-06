{
  programs.zsh.enable = true;
}

# { config, pkgs, lib, ... }:
# let
#   inherit (pkgs.stdenv) isDarwin;
#   inherit (pkgs) system;
#   inherit (config.users) users;
#   inherit (config.flake.outputs.packages.${system}) oh-my-custom;

#   # This is bad as it only assumes a single user - TODO: fix when I have time later
#   user = builtins.getAttr (builtins.head (builtins.attrNames users)) users;

#   inherit (user) name;

#   direnvInit = if config.services.lorri.enable then ''
#     eval "$(direnv hook zsh)"
#   '' else
#     "";

#   environment.systemPackages =
#     if isDarwin then with pkgs; [ oh-my-zsh ] else [ ];

#   ohMyZshInit = if isDarwin then ''
#     export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh/
#   '' else
#     "";

#   ohMyZshPostInit = if isDarwin then ''
#     ZSH_THEME="risto"
#     plugins=(fzf-zsh, zsh-autosuggestions, zsh-syntax-highlighting, git)
#     source $ZSH/oh-my-zsh.sh
#   '' else
#     "";

#   starshipInit = if isDarwin
#   && config.home-manager.users.${name}.programs.starship.enable then ''
#     eval "$(starship init zsh)"
#   '' else
#     "";

#   interactiveShellInit = lib.strings.concatStrings [
#     ohMyZshInit
#     ''
#       HYPHEN_INSENSITIVE="true"
#       ENABLE_CORRECTION="true"
#       COMPLETION_WAITING_DOTS="true"

#       # Preferred editor for local and remote sessions
#       if [[ -n $SSH_CONNECTION ]]; then
#           export EDITOR='vim'
#       else
#           export EDITOR='vim'
#       fi
#     ''
#     ohMyZshPostInit
#     starshipInit
#     direnvInit
#   ];

#   promptInit = "";

#   shellAliases = { "ls" = "lsd"; };

#   darwinConfig = {
#     inherit promptInit interactiveShellInit;

#     enable = true;
#     enableCompletion = true;
#     enableSyntaxHighlighting = true;
#     enableFzfCompletion = true;
#   };

#   linuxConfig = {
#     inherit promptInit interactiveShellInit;

#     enable = true;
#     enableCompletion = true;
#     histSize = 10000;
#     autosuggestions.enable = true;
#     syntaxHighlighting.enable = true;
#     ohMyZsh = {
#       custom = oh-my-custom.outPath;
#       enable = true;
#       theme = "risto";
#       plugins = [ "git" "fzf-zsh" ];
#     };
#   };

# in {
#   environment.shellAliases = shellAliases;
#   programs.zsh = if isDarwin then darwinConfig else linuxConfig;
# }
