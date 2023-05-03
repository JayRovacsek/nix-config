{ self, system }:
let
  pkgs = self.inputs.nixpkgs.legacyPackages.${system};
  inherit (pkgs.lib.attrsets) concatMapAttrs;
  inherit (pkgs) terraform;
  inherit (self.common) terraform-stacks;

  # Commonly utilised terraform file names
  state = "terraform.tfstate";
  config = "config.tf.json";
  lock = ".terraform.lock.hcl";
  vars = "terraform.tfvars";

  # Simple wrapper for removing a file in current directory
  remove = x: ''
    if [[ -e ${x} ]]; then
      echo "Found ${x} to exist, removing it!"
      rm -f ${x}
    fi
  '';

  # Curried functions handling removal of common files
  removeConfig = remove config;
  removeLock = remove lock;
  removeState = remove state;
  removeVars = remove vars;

  # Simple wrapper for using a file if it exists in 
  # stack directory
  use = stack: x: ''
    if [[ -e ./terranix/${stack}/${x} ]]; then
      echo "${x} exists in stack directory, utilising it!"
      ln ./terranix/${stack}/${x} $(pwd)
    fi
  '';

  # Curried use functions for common files
  useState = stack: use stack state;
  useVars = stack: use stack vars;

  runTerraformCommand = command: ''
    ${terraform}/bin/terraform ${command}
  '';

  terraformInit = cfg: ''
    cp ${cfg} config.tf.json \
      && ${terraform}/bin/terraform init
  '';

  update = stack: x: ''
    if [[ -e ${x} ]]; then
      if [[ ! -e ./terranix/${stack}/${x} ]]; then
        echo "Copying ${x} over to the stack directory!"
        ln ${x} ./terranix/${stack}/${x}
      fi
    fi
  '';

  updateState = stack: update stack state;
  updateVars = stack: update stack vars;

  runTfsec = ''
    if [[ -e terraform.tfvars ]]; then
      ${pkgs.tfsec}/bin/tfsec . --tfvars-file terraform.tfvars
    else 
      ${pkgs.tfsec}/bin/tfsec .
    fi

    if [ $? -ne 0 ]; then
      echo "Tfsec returned a non-success code! Review CLI output"
      ${removeState}
      ${removeVars}
      ${removeConfig}
      ${removeLock}
      exit 1
    fi
  '';

  terraformProgram = cfg: stack: name: command:
    builtins.toString (pkgs.writers.writeBash name ''
      ${removeConfig}
      ${removeState}
      ${removeVars}
      ${removeLock}

      ${useState stack}
      ${useVars stack}

      ${terraformInit cfg}

      ${runTfsec}

      ${runTerraformCommand command}

      ${updateState stack}
      ${removeState}

      ${updateVars stack}
      ${removeVars}

      ${removeLock}

      ${removeConfig}
    '');

  terraform-actions = concatMapAttrs (name: _:
    let cfg = self.packages.${system}.${name};
    in {
      "${name}-apply" = {
        type = "app";
        program = terraformProgram cfg name "apply" "apply -auto-approve";
      };

      "${name}-plan" = {
        type = "app";
        program = terraformProgram cfg name "plan" "plan";
      };

      "${name}-sync" = {
        type = "app";
        program = terraformProgram cfg name "sync" "plan -refresh-only";
      };

      "${name}-destroy" = {
        type = "app";
        program = terraformProgram cfg name "destroy" "destroy";
      };
    }) terraform-stacks;

in terraform-actions
