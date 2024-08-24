{ lib, ... }:
with lib;
{
  options.programs.ssh.extraConfig = mkOption {
    type = with types; lines;
    default = "";
    description = ''
      A darwin stub to primarily ignore the inclusion of 
      ssh extraConfig values when build machines are defined and 
      require this as root.
    '';
  };
}
