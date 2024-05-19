{ writers, ... }:
# TODO: figure if I can ever remove the hardcoded site value on the 
# last line of the config
writers.writeTOML "cliff.toml" {
  # https://git-cliff.org/docs/configuration

  changelog = {
    header = "";

    body = ''
      {%- macro remote_url() -%}
        https://github.com/{{ remote.github.owner }}/{{ remote.github.repo }}
      {%- endmacro -%}
      {% macro print_commit(commit) -%}
          - {% if commit.scope %}*({{ commit.scope }})* {% endif %}{% if commit.breaking %}[**breaking**] {% endif %}{{ commit.message | upper_first }} - ([{{ commit.id | truncate(length=7, end="") }}]({{ self::remote_url() }}/commit/{{ commit.id }}))
      {% endmacro -%}
      {% if version %}{% if previous.version %}## [{{ version | trim_start_matches(pat="v") }}]({{ self::remote_url() }}/compare/{{ previous.version }}..{{ version }}) - {{ timestamp | date(format="%Y-%m-%d") }}{% else %}## [{{ version | trim_start_matches(pat="v") }}] - {{ timestamp | date(format="%Y-%m-%d") }}{% endif %}{% else %}## [unreleased]{% endif %}
      {% for group, commits in commits | group_by(attribute="group") %}
          ### {{ group | striptags | trim | upper_first }}
          {% for commit in commits
          | filter(attribute="scope")
          | sort(attribute="scope") %}
              {{ self::print_commit(commit=commit) }}
          {%- endfor -%}
          {% raw %}{% endraw %}

          {%- for commit in commits %}
              {%- if not commit.scope -%}
                  {{ self::print_commit(commit=commit) }}
              {% endif -%}
          {% endfor -%}
      {% endfor %}
    '';
    footer = "";
    trim = true;
  };
  git = {
    # parse the commits based on https://www.conventionalcommits.org
    conventional_commits = true;
    # filter out the commits that are not conventional
    filter_unconventional = true;
    # process each line of a commit as an individual commit
    split_commits = true;
    # regex for parsing and grouping commits
    commit_parsers = [
      {
        message = "^feat";
        group = "<!-- 0 -->⛰️  Features";
      }
      {
        message = "^fix";
        group = "<!-- 1 -->🐛 Bug Fixes";
      }
      {
        message = "^refactor";
        group = "<!-- 2 -->🚜 Refactor";
      }
      {
        message = "^doc";
        group = "<!-- 3 -->📚 Documentation";
      }
      {
        message = "^style";
        group = "<!-- 4 -->🎨 Styling";
      }
      {
        message = "^test";
        group = "<!-- 5 -->🧪 Testing";
      }
      {
        message = "^chore";
        skip = true;
      }
      {
        body = ".*security";
        group = "<!-- 6 -->🛡️ Security";
      }
      {
        body = ".*apps";
        group = "<!-- 7 -->📱 Apps";
      }
      {
        body = ".*checks";
        group = "<!-- 8 -->✅ Checks";
      }
      {
        body = ".*common";
        group = "<!-- 9 -->⚫ Common";
      }
      {
        body = ".*darwin";
        group = "<!-- 10 -->🐧 Darwin";
      }
      {
        body = ".*flake";
        group = "<!-- 11 -->❄️ Flake";
      }
      {
        body = ".*home-manager-modules";
        group = "<!-- 12 -->🏠 HM";
      }
      {
        body = ".*hydra";
        group = "<!-- 13 -->🐍 Hydra";
      }
      {
        body = ".*lib";
        group = "<!-- 14 -->📚 Lib";
      }
      {
        body = ".*linux";
        group = "<!-- 15 -->😘 Linux";
      }
      {
        body = ".*modules";
        group = "<!-- 16 -->🧱 Modules";
      }
      {
        body = ".*options";
        group = "<!-- 17 -->⚙️ Options";
      }
      {
        body = ".*overlays";
        group = "<!-- 18 -->🎭 Overlays";
      }
      {
        body = ".*packages";
        group = "<!-- 19 -->📦 Packages";
      }
      {
        body = ".*secrets";
        group = "<!-- 20 -->🤫 Secrets";
      }
      {
        body = ".*shells";
        group = "<!-- 21 -->🐚 Shells";
      }
      {
        body = ".*tooling";
        group = "<!-- 22 -->⚒️ Tooling";
      }
      {
        body = ".*users";
        group = "<!-- 23 -->🙋 Users";
      }
    ];
    # protect breaking changes from being skipped due to matching a skipping commit_parser
    protect_breaking_commits = false;
    # filter out the commits that are not matched by commit parsers
    filter_commits = true;
    # regex for matching git tags
    tag_pattern = ".*";
    # regex for skipping tags
    skip_tags = "beta|alpha";
    # regex for ignoring tags
    ignore_tags = "rc";
    # sort the tags topologically
    topo_order = false;
    # sort the commits inside sections by oldest/newest order
    sort_commits = "newest";
  };

  remote.github = {
    owner = "JayRovacsek";
    repo = "nix-config";
  };
}
