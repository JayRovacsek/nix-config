{ writers, ... }:
writers.writeTOML "_typos.toml" {
  files.extend-exclude = [ "_typos.toml" "*.age" ];

  default.extend-words = {
    Adge = "Adge";
    ags = "ags";
    ba = "ba";
    browseable = "browseable";
    crypted = "crypted";
    dota = "dota";
    ede = "ede";
    flor = "flor";
    Flor = "Flor";
    gastly = "gastly";
    Gastly = "Gastly";
    no = "no";
    noice = "noice";
    noo = "noo";
    SART = "SART";
    SYNOPSYS = "SYNOPSYS";
    wih = "wih";
  };
}
