{ self, pkgs }:
let
  inherit (pkgs) lib system terraform;
  inherit (lib) concatMapAttrs;
  inherit (self.common) terraform-stacks;

  # Commonly utilised terraform file names
  state = "terraform.tfstate";
  config = "config.tf.json";
  lock = ".terraform.lock.hcl";
  vars = "terraform.tfvars";
  readme = "stack-readme.md";

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
  removeReadme = remove readme;

  # Simple wrapper for using a file if it exists in 
  # stack directory
  use = stack: x: ''
    if [[ -e ./terranix/${stack}/${x} ]]; then
      echo "${x} exists in stack directory, utilising it!"
      ${pkgs.coreutils}/bin/ln ./terranix/${stack}/${x} $(pwd)
    fi
  '';

  # Curried use functions for common files
  useState = stack: use stack state;
  useVars = stack: use stack vars;
  useReadme = stack: use stack readme;

  runTerraformCommand = command: ''
    ${terraform}/bin/terraform ${command} $@
  '';

  terraformInit = cfg: ''
    cp ${cfg} config.tf.json \
      && ${terraform}/bin/terraform init
  '';

  update = stack: x: ''
    if [[ -e ${x} ]]; then
      if [[ ! -e ./terranix/${stack}/${x} ]]; then
        echo "Copying ${x} over to the stack directory!"
        ${pkgs.coreutils}/bin/ln ${x} ./terranix/${stack}/${x}
      fi
    fi
  '';

  renameReadme = stack: ''
    if [[ -e ./terranix/${stack}/${readme} ]]; then
      echo "Renaming readme for ${stack}!"
      ${pkgs.coreutils}/bin/mv ./terranix/${stack}/${readme} ./terranix/${stack}/README.md
    fi
  '';

  updateState = stack: update stack state;
  updateVars = stack: update stack vars;
  updateReadme = stack: update stack readme;

  run-tfdoc = ''
    ${pkgs.terraform-docs}/bin/terraform-docs markdown table --output-file stack-readme.md --output-mode inject .
  '';

  tfsec-ignored-checks = [
    # Kinda by descign most the time
    "github-repositories-private"
    # Not all repos will be suitable for this to be applied
    "github-repositories-enable_vulnerability_alerts"

    # AWS
    # Not worth the extra cost for toy repos
    "aws-lambda-enable-tracing"
    # TODO: resolve once AMI is built
    "aws-ec2-enable-at-rest-encryption"
    # Disable as this fails each time as a false positive
    "aws-ec2-enforce-http-token-imds"
  ];
  tfsec-exclude-statement =
    "--exclude ${builtins.concatStringsSep "," tfsec-ignored-checks}";

  run-tfsec = ''
    if [[ -e terraform.tfvars ]]; then
      ${pkgs.tfsec}/bin/tfsec . --tfvars-file terraform.tfvars ${tfsec-exclude-statement}
    else 
      ${pkgs.tfsec}/bin/tfsec . ${tfsec-exclude-statement}
    fi

    if [ $? -ne 0 ]; then
      echo "Tfsec returned a non-success code! Review CLI output"
      ${removeReadme}
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
      ${removeReadme}
      ${removeState}
      ${removeVars}
      ${removeLock}

      ${useState stack}
      ${useVars stack}
      ${useReadme stack}

      ${terraformInit cfg}

      ${run-tfsec}

      ${run-tfdoc}

      ${runTerraformCommand command}

      ${updateReadme stack}
      ${renameReadme stack}
      ${removeReadme}

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
        program = terraformProgram cfg name "apply" "apply";
      };

      "${name}-init" = {
        type = "app";
        program = terraformProgram cfg name "init" "init";
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

      # To utilise import, we should pass values via the argument style 
      # described here: https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-run.html#examples
      # eg;
      # $ nix run .#thing-import resource.name upstream-identifier
      # OR as a very real example I utilised on implementing this:
      # nix run .\#github-import -- github_repository.dotfiles dotfiles
      # 
      # This is possible thanks to the fact we're certainly running in
      # bash in this setting and can (ab)use the $@ pattern.
      "${name}-import" = {
        type = "app";
        program = terraformProgram cfg name "import" "import";
      };
    }) terraform-stacks;

in terraform-actions
