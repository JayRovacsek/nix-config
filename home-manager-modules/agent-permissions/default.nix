_: {
  # Imported by several agent modules; a stable key stops the module system
  # loading it once per importer.
  key = "home-manager-modules/agent-permissions";

  imports = [ ../../options/home-manager-modules/agent-permissions ];

  programs.agent-permissions = {
    enable = true;

    # -----------------------------------------------------------------
    # External directories the agent may read/write outside the project
    # -----------------------------------------------------------------
    externalDirectories = {
      "~/dev/**" = "allow";
      "/nix/store/**" = "allow";
    };

    # -----------------------------------------------------------------
    # Bash command allow-list
    #
    # Policy: default ask, explicitly allow non-destructive builtins
    # that are common across Linux and macOS, and explicitly deny
    # anything destructive or representing a clear anti-pattern.
    # -----------------------------------------------------------------
    bash = {
      # default — anything not listed requires approval
      "*" = "ask";

      # --- read-only filesystem inspection ---
      "ls*" = "allow";
      "pwd*" = "allow";
      "cat*" = "allow";
      "head*" = "allow";
      "tail*" = "allow";
      "wc*" = "allow";
      "file*" = "allow";
      "stat*" = "allow";
      "readlink*" = "allow";
      "realpath*" = "allow";
      "basename*" = "allow";
      "dirname*" = "allow";
      "du*" = "allow";
      "df*" = "allow";
      "which*" = "allow";
      "whoami*" = "allow";
      "uname*" = "allow";
      "printenv*" = "allow";
      "id*" = "allow";
      "date*" = "allow";
      "tree*" = "allow";
      "test *" = "allow";
      "true*" = "allow";
      "false*" = "allow";
      "hostname*" = "allow";

      # --- systemd / launchd inspection (read-only) ---
      "systemctl status*" = "allow";
      "systemctl show*" = "allow";
      "systemctl list-units*" = "allow";
      "systemctl list-unit-files*" = "allow";
      "systemctl list-timers*" = "allow";
      "systemctl list-sockets*" = "allow";
      "systemctl list-dependencies*" = "allow";
      "systemctl list-jobs*" = "allow";
      "systemctl is-active*" = "allow";
      "systemctl is-enabled*" = "allow";
      "systemctl is-failed*" = "allow";
      "systemctl is-system-running*" = "allow";
      "systemctl cat*" = "allow";
      "systemctl help*" = "allow";
      "systemctl --user status*" = "allow";
      "systemctl --user show*" = "allow";
      "systemctl --user list-units*" = "allow";
      "systemctl --user list-unit-files*" = "allow";
      "systemctl --user list-timers*" = "allow";
      "systemctl --user list-sockets*" = "allow";
      "systemctl --user list-dependencies*" = "allow";
      "systemctl --user list-jobs*" = "allow";
      "systemctl --user is-active*" = "allow";
      "systemctl --user is-enabled*" = "allow";
      "systemctl --user is-failed*" = "allow";
      "systemctl --user is-system-running*" = "allow";
      "systemctl --user cat*" = "allow";
      "systemctl --user help*" = "allow";
      "journalctl*" = "allow";
      "launchctl list*" = "allow";
      "launchctl print*" = "allow";
      "launchctl blame*" = "allow";
      "launchctl dumpstate*" = "allow";
      "launchctl dumpjpcategory*" = "allow";

      # --- search & filter ---
      "find*" = "allow";
      "find*delete*" = "deny";
      "find*-delete*" = "deny";
      "find*-exec*rm*" = "deny";
      "find*-execdir*rm*" = "deny";
      "find*-ok*rm*" = "deny";
      "find*-exec*unlink*" = "deny";
      "find*-execdir*unlink*" = "deny";
      "fd*" = "allow";
      "grep*" = "allow";
      "rg*" = "allow";
      "awk*" = "allow";
      "sed*" = "allow";
      "sort*" = "allow";
      "uniq*" = "allow";
      "tr *" = "allow";
      "cut*" = "allow";
      "diff*" = "allow";
      "comm*" = "allow";
      "tee*" = "allow";
      "xargs*" = "allow";

      # --- text & data processing ---
      "echo*" = "allow";
      "printf*" = "allow";
      "jq*" = "allow";
      "yq*" = "allow";

      # --- safe filesystem mutations ---
      "mkdir*" = "allow";
      "cp *" = "allow";
      "mv *" = "allow";
      "touch*" = "allow";
      "ln*" = "allow";

      # --- nix (the whole point) ---
      "nix*" = "allow";
      "nixfmt*" = "allow";
      "deadnix*" = "allow";
      "statix*" = "allow";

      # --- dbt (analytics engineering) ---
      "dbt*" = "allow";
      "dbtf*" = "allow";

      # --- git (non-destructive / read-only) ---
      "git status*" = "allow";
      "git diff*" = "allow";
      "git log*" = "allow";
      "git show*" = "allow";
      "git branch*" = "allow";
      "git remote*" = "allow";
      "git rev-parse*" = "allow";
      "git ls-tree*" = "allow";
      "git ls-files*" = "allow";
      "git ls-remote*" = "allow";
      "git describe*" = "allow";
      "git tag*" = "allow";
      "git config --get*" = "allow";
      "git config --list*" = "allow";
      "git rev-list*" = "allow";
      "git shortlog*" = "allow";
      "git blame*" = "allow";
      "git worktree list*" = "allow";
      "git cat-file*" = "allow";
      "git name-rev*" = "allow";
      "git merge-base*" = "allow";

      # --- git (write, but safe / standard workflow) ---
      "git add*" = "allow";
      "git commit*" = "allow";
      "git checkout*" = "allow";
      "git switch*" = "allow";
      "git stash*" = "allow";
      "git fetch*" = "allow";
      "git pull*" = "allow";
      "git merge*" = "allow";
      "git rebase*" = "allow";
      "git cherry-pick*" = "allow";
      "git push*" = "ask";

      # -----------------------------------------------------------------
      # DENY: destructive commands and clear anti-patterns
      #
      # These are never appropriate for an AI agent to run without
      # extremely deliberate human intent — block them outright.
      # -----------------------------------------------------------------
      "rm -rf*" = "deny";
      "chmod -R 777*" = "deny";
      "chmod 777*" = "deny";
      "dd *" = "deny";
      "mkfs*" = "deny";
      "shutdown*" = "deny";
      "reboot*" = "deny";
      "halt*" = "deny";
      "poweroff*" = "deny";
      "init *" = "deny";
      "kill -9*" = "deny";
      "killall*" = "deny";
      "pkill*" = "deny";
      ":(){*" = "deny"; # fork bomb
      "curl*|*sh" = "deny"; # pipe-to-shell
      "wget*|*sh" = "deny"; # pipe-to-shell
      "sudo*" = "deny";
      "su *" = "deny";
      "doas*" = "deny";

      # --- git destructive operations ---
      "git push --force*" = "deny";
      "git push -f*" = "deny";
      "git clean -fd*" = "deny";
      "git reset --hard*" = "deny";

      # --- git --no-verify: blocks hook-skipping across all git commands ---
      # --no-verify skips pre-commit and commit-msg hooks, violating
      # commit policy enforcement. This flag is dangerous in any context.
      "git commit*--no-verify*" = "deny";
      "git merge*--no-verify*" = "deny";
      "git cherry-pick*--no-verify*" = "deny";
      "git am*--no-verify*" = "deny";
      "git rebase*--no-verify*" = "deny";
      "git send-email*--no-verify*" = "deny";

      # --- git commit signing bypass: enforce GPG signing ---
      # `--no-gpg-sign` turns off signing for a single commit (overriding
      # `commit.gpgsign=true`); it has no short form, so it is matched
      # explicitly. `-n` is the `--no-verify` short form (see above) and is
      # also denied here. The leading space on the `-n` pattern anchors it
      # to a flag boundary so message text containing "-n" substrings
      # (e.g. model names like `flash-next`) does not trip the rule.
      "git commit* -n*" = "deny";
      "git commit*--no-gpg-sign*" = "deny";

      # -----------------------------------------------------------------
      # DENY: arbitrary package runners & installers
      #
      # These tools fetch and execute unvetted, unpinned code from
      # public registries. All package management in this repository
      # goes through Nix — anything else is an anti-pattern.
      # -----------------------------------------------------------------

      # --- Node.js / JavaScript ecosystem ---
      "npx*" = "deny";
      "bunx*" = "deny";
      "pnpx*" = "deny";
      "pnpm dlx*" = "deny";
      "yarn dlx*" = "deny";
      "npm install*" = "deny";
      "npm i *" = "deny";
      "npm ci*" = "deny";
      "yarn install*" = "deny";
      "yarn add*" = "deny";
      "bun install*" = "deny";
      "bun add*" = "deny";
      "pnpm install*" = "deny";
      "pnpm add*" = "deny";
      "volta install*" = "deny";
      "corepack enable*" = "deny";
      "corepack prepare*" = "deny";

      # --- Python ecosystem ---
      "uvx*" = "deny";
      "pipx run*" = "deny";
      "pipx install*" = "deny";
      "pip install*" = "deny";
      "pip3 install*" = "deny";
      "uv pip install*" = "deny";
      "uv tool install*" = "deny";
      "uv tool run*" = "deny";
      "poetry install*" = "deny";
      "poetry add*" = "deny";
      "pdm install*" = "deny";
      "pdm add*" = "deny";
      "conda install*" = "deny";
      "conda create*" = "deny";
      "mamba install*" = "deny";
      "mamba create*" = "deny";
      "micromamba install*" = "deny";

      # --- Rust ecosystem ---
      "cargo install*" = "deny";
      "cargo binstall*" = "deny";
      "cargo-binstall*" = "deny";

      # --- Go ecosystem ---
      "go install*" = "deny";
      "go run *://*" = "deny"; # remote module URLs

      # --- Deno (remote execution) ---
      "deno run http*" = "deny";
      "deno install*" = "deny";
      "deno add*" = "deny";

      # --- Ruby ecosystem ---
      "gem install*" = "deny";
      "bundle install*" = "deny";
      "bundle add*" = "deny";

      # --- PHP ecosystem ---
      "composer require*" = "deny";
      "composer install*" = "deny";
      "composer update*" = "deny";

      # --- Nix (imperative anti-patterns) ---
      "nix-env -i*" = "deny";
      "nix-env --install*" = "deny";

      # --- System package managers (bypass Nix) ---
      "brew install*" = "deny";
      "brew upgrade*" = "deny";
      "port install*" = "deny";
      "apt install*" = "deny";
      "apt-get install*" = "deny";
      "yum install*" = "deny";
      "dnf install*" = "deny";
      "zypper install*" = "deny";
      "pacman -S*" = "deny";
      "apk add*" = "deny";
      "snap install*" = "deny";
      "flatpak install*" = "deny";

      # --- Container (unpinned image pulls) ---
      "docker run*" = "deny";
      "docker pull*" = "deny";
      "podman run*" = "deny";
      "podman pull*" = "deny";
    };
  };
}
