{ lib, ... }:
with lib; {
  options.services.headscale = {
    # TODO: make the below a submodule that
    # exposes name, ephemerality and 
    # secretsFile so we can abstract agenix out
    tailnets = mkOption {
      type = with types; listOf str;
      default = [ ];
    };
  };
}
