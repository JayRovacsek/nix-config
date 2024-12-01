{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  version = "6.12.2";
  pname = "cloudquery";

  src = fetchFromGitHub {
    owner = "cloudquery";
    repo = "cloudquery";
    rev = "v${version}";
    hash = "sha256-hHllESbNCd+NZYi/wTcalPtawNmlL8c+vi6db2UmRb0=";
  };

  vendorHash = "sha256-SdPqjFnKakU4bajGu/AROmbgYTBHnB9iac9snaryMhU=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/cloudquery/cloudquery";
    description = "Transform your cloud infrastructure into queryable SQL tables for easy monitoring, governance and security";
    license = licenses.mpl20;
  };
}
