_: {
  imports = [ ../../options/modules/laya ];

  services.laya = {
    enable = true;
    instances = {
      q4 = {
        model = {
          repo = "mys/laya-GGUF";
          file = "laya_english_ud_q4_k_m.gguf";
        };
        port = 8082;
        openFirewall = true;
        device = "cuda";
      };
    };
  };
}
