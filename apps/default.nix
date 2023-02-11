{ self, system }:
let
  pkgs = self.inputs.unstable.legacyPackages.${system};
  inherit (pkgs) terraform;

  terranix-stacks = builtins.attrNames (builtins.readDir ../terranix);

  terraform-actions = builtins.foldl' (acc: stack:
    let cfg = self.packages.${system}.${stack};
    in {
      "${stack}-apply" = {
        type = "app";
        program = builtins.toString (pkgs.writers.writeBash "apply" ''
          # Remove old config.tf.json
          if [[ -e config.tf.json ]]; then
            rm -f config.tf.json
          fi
          # Run the apply
          cp ${cfg} config.tf.json \
            && ${terraform}/bin/terraform init \
            && ${terraform}/bin/terraform apply -auto-approve
          # Remove old config.tf.json and if successful
          if [[ $? && -e config.tf.json ]]; then
            rm -f config.tf.json
          fi
        '');
      };

      "${stack}-destroy" = {
        type = "app";
        program = builtins.toString (pkgs.writers.writeBash "destroy" ''
          # Remove old config.tf.json
          if [[ -e config.tf.json ]]; then
            rm -f config.tf.json
          fi
          # Run the destroy
          cp ${cfg} config.tf.json \
            && ${terraform}/bin/terraform init \
            && ${terraform}/bin/terraform destroy
          # Remove old config.tf.json and if successful
          if [[ $? && -e config.tf.json ]]; then
            rm -f config.tf.json
          fi
        '');
      };
    } // acc) { } terranix-stacks;

in terraform-actions
