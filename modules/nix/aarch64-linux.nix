{ flake, ... }:
# Same options apply between x86_64 and aarch64 as far as I require
let x86Config = import ./x86_64-linux.nix { inherit flake; };
in x86Config
