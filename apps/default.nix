{ self, system }:
let
  pkgs = self.inputs.unstable.legacyPackages.${system};
  inherit (pkgs) terraform;
  removeConfig = ''
    if [[ -e config.tf.json ]]; then
      rm -f config.tf.json
    fi
  '';

  removeState = ''
    if [[ -e terraform.tfstate ]]; then
      echo "State exists in current directory, removing it!"
      rm -f terraform.tfstate
    fi
  '';

  removeVars = ''
    if [[ -e terraform.tfvars ]]; then
      echo "State exists in current directory, removing it!"
      rm -f terraform.tfvars
    fi
  '';

  useState = stack: ''
    if [[ -e ./terranix/${stack}/terraform.tfstate ]]; then
      echo "State exists in stack directory, utilising it!"
      ln ./terranix/${stack}/terraform.tfstate $(pwd)
    fi
  '';

  useVars = stack: ''
    if [[ -e ./terranix/${stack}/terraform.tfvars ]]; then
      echo "Vars file exists in stack directory, utilising it!"
      ln ./terranix/${stack}/terraform.tfvars $(pwd)
    fi
  '';

  runTerraformCommand = command: ''
    ${terraform}/bin/terraform ${command}
  '';

  terraformInit = cfg: ''
    cp ${cfg} config.tf.json \
      && ${terraform}/bin/terraform init
  '';

  updateState = stack: ''
    if [[ -e terraform.tfstate ]]; then
      if [[ ! -e ./terranix/${stack}/terraform.tfstate ]]; then
        echo "Copying state over to the stack directory!"
        ln terraform.tfstate ./terranix/${stack}/terraform.tfstate
      fi
    fi
  '';

  updateVars = stack: ''
    if [[ -e terraform.tfvars ]]; then
      if [[ ! -e ./terranix/${stack}/terraform.tfvars ]]; then
        echo "Copying tfvars over to the stack directory!"
        ln terraform.tfvars ./terranix/${stack}/terraform.tfvars
      fi
    fi
  '';

  gitStash = ''
    ${pkgs.git}/bin/git stash 1> /dev/null
  '';

  gitStashPop = ''
    ${pkgs.git}/bin/git stash pop 1> /dev/null
  '';

  runTfsec = ''
    ${pkgs.tfsec}/bin/tfsec .
    if [ $? -ne 0 ]; then
      echo "Tfsec returned a non-success code! Review CLI output"
      ${removeState}
      ${removeVars}
      ${removeConfig}
      ${gitStashPop}
      exit 1
    fi
  '';

  terranix-stacks = builtins.attrNames (builtins.readDir ../terranix);

  terraformProgram = cfg: stack: name: command:
    builtins.toString (pkgs.writers.writeBash name ''
      ${gitStash}
      ${removeConfig}
      ${removeState}
      ${removeVars}

      ${useState stack}
      ${useVars stack}

      ${terraformInit cfg}

      ${runTfsec}

      ${runTerraformCommand command}

      ${updateState stack}
      ${removeState}

      ${updateVars stack}
      ${removeVars}

      ${removeConfig}
      ${gitStashPop}
    '');

  terraform-actions = builtins.foldl' (acc: stack:
    let cfg = self.packages.${system}.${stack};
    in {
      "${stack}-apply" = {
        type = "app";
        program = terraformProgram cfg stack "apply" "apply -auto-approve";
      };

      "${stack}-plan" = {
        type = "app";
        program = terraformProgram cfg stack "plan" "plan";
      };

      "${stack}-sync" = {
        type = "app";
        program = terraformProgram cfg stack "sync" "plan -refresh-only";
      };

      "${stack}-destroy" = {
        type = "app";
        program = terraformProgram cfg stack "destroy" "destroy";
      };
    } // acc) { } terranix-stacks;

in terraform-actions
