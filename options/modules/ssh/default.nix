{ lib, ... }:
{
  options.programs.ssh.publicHostKeyBase64 = lib.mkOption {
    type = with lib.types; nullOr str;
    default = null;
    description = ''
      A basic way to describe public keys that a host would present 
      via ssh for consumption by services that need to know the value
      ahead of a connection to avoid diminishing key validation 
      security of a host.

      Note this is in base64 intentionally, as is required by nix
      remote builders; see more: 
      https://github.com/NixOS/nixpkgs/blob/1355a0cbfeac61d785b7183c0caaec1f97361b43/nixos/modules/config/nix-remote-build.nix#L165
    '';
  };
}
