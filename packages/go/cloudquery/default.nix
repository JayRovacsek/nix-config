{ lib, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  version = "0.32.3";
  pname = "cloudquery";

  src = fetchFromGitHub {
    owner = "cloudquery";
    repo = "cloudquery";
    rev = "v${version}";
    sha256 = "sha256-u0s8snPtRChoP5n8zGUwAG2N6jzKhqAOm2QvN4CY/CI=";
  };

  vendorHash = "sha256-SdPqjFnKakU4bajGu/AROmbgYTBHnB9iac9snaryMhU=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/cloudquery/cloudquery";
    description =
      "Transform your cloud infrastructure into queryable SQL tables for easy monitoring, governance and security";
    license = licenses.mpl20;
  };
}
