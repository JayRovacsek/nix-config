{ lib, python, fetchFromGitHub, ... }:
python.sqlalchemy.overrideAttrs (_old: rec {
  version = "2.0.19";
  src = fetchFromGitHub {
    owner = "sqlalchemy";
    repo = "sqlalchemy";
    rev = "refs/tags/rel_${lib.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-97q04wQVtlV2b6VJHxvnQ9ep76T5umn1KI3hXh6a8kU=";
  };
})
