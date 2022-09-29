{
  age = {

    # This is required while https://github.com/ryantm/agenix/pull/107 is still open.
    # The options for this may change 
    # Note that the agenix keys can be written to either of these locations:
    # https://github.com/montchr/agenix/blob/36d70a4a1d0f1aaab60bd70c88c9010d9cc7abe8/modules/age.nix#L191

    sshKeyPaths = [ /Users/j.rovacsek/.ssh/id-ed25519-ssh-primary ];

    secrets = {
      "j.rovacsek-id-ed25519-sk-type-a-1" = {
        file = ../../secrets/ssh/jay-id-ed25519-sk-type-a-1.age;
        owner = "j.rovacsek";
      };

      "j.rovacsek-id-ed25519-sk-type-a-2" = {
        file = ../../secrets/ssh/jay-id-ed25519-sk-type-a-2.age;
        owner = "j.rovacsek";
      };

      "j.rovacsek-id-ed25519-sk-type-c-1" = {
        file = ../../secrets/ssh/jay-id-ed25519-sk-type-c-1.age;
        owner = "j.rovacsek";
      };

      "j.rovacsek-id-ed25519-sk-type-c-2" = {
        file = ../../secrets/ssh/jay-id-ed25519-sk-type-c-2.age;
        owner = "j.rovacsek";
      };
    };
  };
}
