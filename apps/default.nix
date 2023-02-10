{ self, system }:
let
  pkgs = self.inputs.unstable.legacyPackages.${system};
  inherit (pkgs) terraform;
in {
  # TODO: make this dynamically generate an apply and destroy per 
  # tf stack within the terranix folder so it'll never need thought again. 

  # Explicitly leave a default out for now as we do not have a singular deploy target,
  # likely more than one in the future.
  apply = {
    type = "app";
    program = builtins.toString (pkgs.writers.writeBash "apply" ''
      # Remove old config.tf.json
      if [[ -e config.tf.json ]]; then
        rm -f config.tf.json
      fi
      # Run the apply
      cp ${terraformConfiguration} config.tf.json \
        && ${terraform}/bin/terraform init \
        && ${terraform}/bin/terraform apply -auto-approve
      # Remove old config.tf.json and if successful
      if [[ $? && -e config.tf.json ]]; then
        rm -f config.tf.json
      fi
    '');
  };

  destroy = {
    type = "app";
    program = builtins.toString (pkgs.writers.writeBash "destroy" ''
      # Remove old config.tf.json
      if [[ -e config.tf.json ]]; then
        rm -f config.tf.json
      fi
      # Run the destroy
      cp ${terraformConfiguration} config.tf.json \
        && ${terraform}/bin/terraform init \
        && ${terraform}/bin/terraform destroy
      # Remove old config.tf.json and if successful
      if [[ $? && -e config.tf.json ]]; then
        rm -f config.tf.json
      fi
    '');
  };
}
