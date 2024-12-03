{
  lib,
  buildGoModule,
  fetchFromGitHub,
  coreutils,
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

  sourceRoot = "source/cli";

  vendorHash = "sha256-0TglUg/3i1Sbyz9TUhwr+GaZ2CPGwxfAfxZ/iZKw7l0=";

  ## These tests assume network access
  postPatch = ''
    ${coreutils}/bin/rm cmd/addon_download_test.go
    ${coreutils}/bin/rm cmd/addon_publish_test.go
    ${coreutils}/bin/rm cmd/plugin_publish_test.go
    ${coreutils}/bin/rm cmd/switch_test.go
  '';

  meta = with lib; {
    homepage = "https://github.com/cloudquery/cloudquery";
    description = "Transform your cloud infrastructure into queryable SQL tables for easy monitoring, governance and security";
    license = licenses.mpl20;
  };
}
