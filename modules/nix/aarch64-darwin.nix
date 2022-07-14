{ ... }:
# Same options apply between x86_64 and aarch64 as far as I require
let config = import ./x86_64-darwin.nix;
in config
