{ pkgs, ... }:
let
  configs = { x86_64-darwin = import ./x86_64-darwin.nix;
  
  x86_64-linux = import ./x86_64-linux.nix; 
aarch64-linux = import ./x86_64-linux.nix;
   };
in 
{
  time.timeZone = "Australia/Sydney";
  services = {} // configs.${pkgs.system};
}