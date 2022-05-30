{
  age = {

    # This is required while https://github.com/ryantm/agenix/pull/107 is still open.
    # The options for this may change 
    # Note that the agenix keys can be written to either of these locations:
    # https://github.com/montchr/agenix/blob/36d70a4a1d0f1aaab60bd70c88c9010d9cc7abe8/modules/age.nix#L191

    # sshKeyPaths = [ /Users/jrovacsek/.ssh/id_ed25519_sk_agenix ];

    secrets = {
      id_ed25519_sk_type_a_1 = {
        file = ../../secrets/id_ed25519_sk_type_a_1.age;
        path = "/Users/jrovacsek/.ssh/id_ed25519_sk_type_a_1";
        owner = "jrovacsek";
      };

      id_ed25519_sk_type_a_1_pub = {
        file = ../../secrets/id_ed25519_sk_type_a_1.pub.age;
        path = "/Users/jrovacsek/.ssh/id_ed25519_sk_type_a_1.pub";
        owner = "jrovacsek";
      };

      id_ed25519_sk_type_a_2 = {
        file = ../../secrets/id_ed25519_sk_type_a_2.age;
        path = "/Users/jrovacsek/.ssh/id_ed25519_sk_type_a_2";
        owner = "jrovacsek";
      };

      id_ed25519_sk_type_a_2_pub = {
        file = ../../secrets/id_ed25519_sk_type_a_2.pub.age;
        path = "/Users/jrovacsek/.ssh/id_ed25519_sk_type_a_2.pub";
        owner = "jrovacsek";
      };

      id_ed25519_sk_type_c_1 = {
        file = ../../secrets/id_ed25519_sk_type_c_1.age;
        path = "/Users/jrovacsek/.ssh/id_ed25519_sk_type_c_1";
        owner = "jrovacsek";
      };

      id_ed25519_sk_type_c_1_pub = {
        file = ../../secrets/id_ed25519_sk_type_c_1.pub.age;
        path = "/Users/jrovacsek/.ssh/id_ed25519_sk_type_c_1.pub";
        owner = "jrovacsek";
      };

      id_ed25519_sk_type_c_2 = {
        file = ../../secrets/id_ed25519_sk_type_c_2.age;
        path = "/Users/jrovacsek/.ssh/id_ed25519_sk_type_c_2";
        owner = "jrovacsek";
      };

      id_ed25519_sk_type_c_2_pub = {
        file = ../../secrets/id_ed25519_sk_type_c_2.pub.age;
        path = "/Users/jrovacsek/.ssh/id_ed25519_sk_type_c_2.pub";
        owner = "jrovacsek";
      };

      jrovacsek_ssh_config = {
        file = ../../secrets/jay_ssh_config.age;
        path = "/Users/jrovacsek/.ssh/config";
        owner = "jrovacsek";
      };
    };
  };
}
