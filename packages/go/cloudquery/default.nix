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
  postPatch =
    let
      rm = "${coreutils}/bin/rm";
    in
    ''
      ${rm} cmd/addon_download_test.go
      ${rm} cmd/addon_publish_test.go
      ${rm} cmd/infer_test.go
      ${rm} cmd/init_test.go
      ${rm} cmd/install_test.go
      ${rm} cmd/plugin_publish_test.go
      ${rm} cmd/switch_test.go
    '';

  meta = with lib; {
    homepage = "https://github.com/cloudquery/cloudquery";
    description = "Transform your cloud infrastructure into queryable SQL tables for easy monitoring, governance and security";
    license = licenses.mpl20;
  };
}
