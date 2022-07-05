{

  # todo:  align these with user, write function to dynamically generate based on user configs
  age = {
    # Secondary keys are included but unutilised if the file doesn't exist
    identityPaths = [
      "/agenix/id-ed25519-meta-primary"
      # "/agenix/id-ed25519-meta-secondary"
      "/agenix/id-ed25519-tailscale-primary"
      # "/agenix/id-ed25519-tailscale-secondary"
      "/agenix/id-ed25519-ssh-primary"
      # "/agenix/id-ed25519-ssh-secondary"
    ];

    secrets = {
      jay-id-ed25519-sk-type-a-1 = {
        file = ../../secrets/jay-id-ed25519-sk-type-a-1.age;
        owner = "jay";
      };

      jay-id-ed25519-sk-type-a-2 = {
        file = ../../secrets/jay-id-ed25519-sk-type-a-2.age;
        owner = "jay";
      };

      jay-id-ed25519-sk-type-c-1 = {
        file = ../../secrets/jay-id-ed25519-sk-type-c-1.age;
        owner = "jay";
      };

      jay-id-ed25519-sk-type-c-2 = {
        file = ../../secrets/jay-id-ed25519-sk-type-c-2.age;
        owner = "jay";
      };
    };
  };
}
