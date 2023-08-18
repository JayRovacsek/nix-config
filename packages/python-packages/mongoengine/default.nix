{ python, fetchFromGitHub, ... }:
python.mongoengine.overrideAttrs (old: rec {
  version = "0.27.0";
  src = fetchFromGitHub {
    owner = "MongoEngine";
    repo = old.pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-UCd7RpsSNDKh3vgVRYrFYWYVLQuK7WI0n/Moukhq5dM=";
  };
})
