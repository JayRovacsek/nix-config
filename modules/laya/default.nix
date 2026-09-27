_: {
  imports = [ ../../options/modules/laya ];

  services.laya = {
    enable = true;
    instances = {
      email = {
        model = {
          repo = "mys/laya-GGUF";
          file = "laya_english_ud_q4_k_m.gguf";
        };
        port = 8080;
        openFirewall = true;
      };

      triage = {
        model = {
          repo = "mys/laya-GGUF";
          file = "laya_english_q8_0.gguf";
        };
        port = 8081;
      };
    };
  };
}
