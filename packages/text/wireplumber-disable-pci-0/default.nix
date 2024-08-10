{
  coreutils,
  stdenvNoCC,
  writeTextFile,
  ...
}:
let
  name = "51-alsa-disable.lua";
  # Note the below should be injected into location blocks of vhosts
  # if authelia is running
  file = writeTextFile {
    inherit name;
    text = ''
      rule = {
        matches = {
          {
            { "device.name", "equals", "alsa_card.pci-0000_01_00.1" },
          },
        },
        apply_properties = {
          ["device.disabled"] = true,
        },
      }

      table.insert(alsa_monitor.rules,rule)
    '';
  };
in
stdenvNoCC.mkDerivation {
  inherit name;

  phases = [ "installPhase" ];

  installPhase = ''
    ${coreutils}/bin/mkdir -p $out/share/wireplumber/main.lua.d
    ${coreutils}/bin/ln -s ${file} $out/share/wireplumber/main.lua.d/${name}
  '';
}
