{ lib, stdenv, gnutls, coreutils, writeTextFile, domain ? "localhost"
, seed ? "0000000000000000000000000000000000000000000000000000000000000000" }:
let
  pname = "self-signed-certificate";

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
    # Serial here needs to be unlikely to match with another certificate.
    # There's likely better ways to achieve this here, but for now all we're
    # going to do is split domain into chars, pull their ASCII value, sum
    # the values and then stringify it to get this effect to an extent while staying deterministic in output.
    # 
    # As these certificates are only ever for testing purposes, seems completely
    # reasonable.
    text = ''
      serial = ${
        builtins.toString (builtins.foldl' (acc: x: acc + x) 0
          (builtins.map (char: lib.strings.charToInt char)
            (lib.stringToCharacters domain)))
      }
      activation_date = "0000-01-01 00:00:00 UTC"
      expiration_date = "9999-12-31 23:59:59 UTC"
      dns_name = "${builtins.toString domain}"
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

in stdenv.mkDerivation { inherit pname version meta phases buildPhase; }
