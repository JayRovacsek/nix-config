{ stdenv, pkgs, lib }:
with lib;
let
  name = "oh-my-custom";
  pname = "oh-my-custom";
  version = "0.0.1";
  meta = {
    description =
      "A nicer way to manage externally available ZSH options that currently aren't in nixpkgs";
    platforms = platforms.unix;
  };

  phases = [ "installPhase" "fixupPhase" ];

  plugins = with pkgs; [ fzf-zsh ];
  themes = with pkgs; [ ];

  createPluginFolders =
    lib.concatMapStringsSep "\n" (p: "mkdir -p $out/plugins/${p.pname}")
    plugins;

  # See also: https://github.com/ohmyzsh/ohmyzsh/wiki/Customization#adding-a-new-plugin
  linkPlugins = lib.concatMapStringsSep "\n" (p: ''
    find ${p.outPath} -type f -name "*.plugin.zsh" -exec ln -s '{}' $out/plugins/${
      builtins.replaceStrings [ "-unstable" ] [ "" ] p.pname
    } ';' 
  '') plugins;

  # See also: https://github.com/ohmyzsh/ohmyzsh/wiki/Customization#overriding-and-adding-themes
  linkThemes = lib.concatMapStringsSep "\n" (p: ''
    find ${p.outPath} -type f -name "*.zsh-theme" -exec ln -s '{}' $out/themes/ ';' 
  '') themes;

in stdenv.mkDerivation {
  inherit name pname version meta phases;

  installPhase = ''
    mkdir -p $out/plugins
    mkdir -p $out/themes
    ${createPluginFolders}
    ${linkPlugins}
    ${linkThemes}
  '';
}
