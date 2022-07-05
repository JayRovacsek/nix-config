{ name, config, lib }:
let
  sshKeys =
    builtins.filter (x: lib.strings.hasInfix "${name}-id-ed25519" x.name)
    (builtins.attrValues config.age.secrets);
in sshKeys
