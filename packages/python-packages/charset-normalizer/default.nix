{ python, ... }:
python.charset-normalizer.overrideAttrs (_old: rec {
  version = "3.2.0";
  src = fetchFromGitHub {
    owner = "Ousret";
    repo = "charset_normalizer";
    rev = "refs/tags/${version}";
    hash = "sha256-CfL5rlrwJs9453z+1xPUzs1B3OyjFBaU6klzY7gJCzA=";
  };
})
