_:
let
  # Note host below should be a nixosConfiguration
  # running hydra and consuming our custom nix options 
  generate-spec = host: {
    enabled = 1;
    hidden = false;
    description = "nix-config auto-generated";
    nixexprinput = "nixexpr";
    nixexprpath = ".hydra/jobsets.nix";
    checkinterval = 60;
    schedulingshares = 100;
    enableemail = false;
    emailoverride = "";
    keepnr = 3;
    type = 0;
    inputs = {
      nixexpr = {
        emailresponsible = false;
        type = "git";
        value = "https://github.com/JayRovacsek/nix-config main";
      };
      nixpkgs = {
        emailresponsible = false;
        type = "path";
        # Avoiding cloning all of nixpkgs is great when we already 
        # ensure the reproducibility of nixpkgs as a channel/source 
        # for the spaces that do ye' old import <nixpkgs>
        # as per the nix options definition in options/nix/default.
        # (see environment definitions)
        # There is a single footgun here: if our target has an older version
        # than what exists in the flake inputs (we haven't rebuilt yet)
        # we'll see an error in evaluation that the source couldn't be 
        # found.
        value = host.config.environment.etc."nix/inputs/nixpkgs".source.outPath;
      };
      pulls = {
        emailresponsible = false;
        type = "githubpulls";
        value = "JayRovacsek nix-config";
      };
    };
  };

in { inherit generate-spec; }
