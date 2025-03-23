{
  lib,
  buildGoModule,
  fetchFromGitHub,
  coreutils,
}:
buildGoModule rec {
  version = "6.16.0";
  pname = "cloudquery";

  src = fetchFromGitHub {
    owner = "cloudquery";
    repo = "cloudquery";
    rev = "v${version}";
    hash = "sha256-4UxYReimGpKHzjUbg5rzwskaPnyOLrF7EJ0sAaBmGSc=";
  };

  sourceRoot = "source/cli";

  vendorHash = "sha256-4Bje9srG0QNZqeQbDlC26tqoFNBTOO6hzG6QsW+dfxI=";

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
      ${rm} cmd/migrate_test.go
      ${rm} cmd/plugin_publish_test.go
      ${rm} cmd/switch_test.go
      ${rm} cmd/sync_test.go
      ${rm} cmd/tables_test.go
      ${rm} cmd/test_connection_test.go
      ${rm} cmd/validate_config_test.go
    '';

  meta = with lib; {
    homepage = "https://github.com/cloudquery/cloudquery";
    description = "Transform your cloud infrastructure into queryable SQL tables for easy monitoring, governance and security";
    license = licenses.mpl20;
  };
}
