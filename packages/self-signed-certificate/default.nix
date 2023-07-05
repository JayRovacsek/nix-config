{ lib, stdenv, gnutls, coreutils, writeTextFile, domain ? "localhost"
, seed ? "0000000000000000000000000000000000000000000000000000000000000000" }:
let
  pname = "self-signed-certificate";
  name = pname;
  version = "0.0.1";

  meta = with lib; {
    homepage = "https://127.0.0.1/";
    description = "A self signed certificate for development work";
    license = licenses.mit;
    inherit (gnutls.meta) platforms;
  };

  # Ensure deterministic values for common non-deterministic ones.
  template = writeTextFile {
    name = "cert.cfg";
    text = ''
      serial = 1
      activation_date = "0000-01-01 00:00:00 UTC"
      expiration_date = "9999-12-31 23:59:59 UTC"
      dns_name = "*.${builtins.toString domain}"
      ip_address = "127.0.0.1"
    '';
  };

  # Follows https://stackoverflow.com/questions/22759465/making-openssl-generate-deterministic-key/59329138#59329138
  buildPhase = ''
    ${coreutils}/bin/mkdir -p $out/share

    ${gnutls}/bin/certtool --generate-privkey --outfile privkey.pem --key-type=rsa --sec-param=high --seed=${seed}
    ${gnutls}/bin/certtool --to-rsa --load-privkey privkey.pem --outfile privkey.key
    ${gnutls}/bin/certtool --generate-self-signed --load-privkey privkey.key --outfile self-signed.crt --template ${template}

    cp self-signed.crt privkey.key $out/share
  '';

  phases = [ "buildPhase" ];

in stdenv.mkDerivation { inherit name pname version meta phases buildPhase; }
