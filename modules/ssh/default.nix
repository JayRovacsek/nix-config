_: {
  age = {
    identityPaths = [ "/agenix/id-ed25519-ssh-primary" ];

    secrets = {
      type-a-1 = {
        file = ../../secrets/ssh/type-a-1.age;
        owner = "jay";
      };
      type-c-1 = {
        file = ../../secrets/ssh/type-c-1.age;
        owner = "jay";
      };
      type-a-2 = {
        file = ../../secrets/ssh/type-a-2.age;
        owner = "jay";
      };
      type-c-2 = {
        file = ../../secrets/ssh/type-c-2.age;
        owner = "jay";
      };
    };
  };
}
