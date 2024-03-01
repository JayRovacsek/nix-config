## [unreleased]

### ⛰️  Features

- *(darwin)* Add trdsql package back to victreebel - ([ca18a44](https://github.com/JayRovacsek/nix-config/commit/ca18a449d0da38629dfe24e5627ce5e4eb3bed16))
- *(flake)* Enable system agnostic overlays to be utilised in flake - ([25b9149](https://github.com/JayRovacsek/nix-config/commit/25b9149a83e27c6120ceb0b21ca45892506f18ed))
- *(linux)* Add zfs dataset to dragonite (osts) - ([004159b](https://github.com/JayRovacsek/nix-config/commit/004159b1c29647c886ae9a7db567439962492429))
- *(modules)* Enable nix binary cache on linux-builder - ([5466cdc](https://github.com/JayRovacsek/nix-config/commit/5466cdce52f072e441f0d6000f55ac7e6f8cef1f))
- *(modules)* Add linux builder to darwin settings - ([4b2e4f9](https://github.com/JayRovacsek/nix-config/commit/4b2e4f9f17b3711915f1cc17b4ddfe8725d7a400))
- *(options)* Enable emulated systems for linux-builder - ([5466cdc](https://github.com/JayRovacsek/nix-config/commit/5466cdce52f072e441f0d6000f55ac7e6f8cef1f))
- *(overlays)* Move overlay system binds to common space + remove from package-sets - ([25b9149](https://github.com/JayRovacsek/nix-config/commit/25b9149a83e27c6120ceb0b21ca45892506f18ed))
- *(packages)* Implement prettierignore config as a package - ([305ef53](https://github.com/JayRovacsek/nix-config/commit/305ef53311a60df3997652c668f331b1f25ca313))
- *(tooling)* Add cliff.toml file to ensure consistent changelog generation - ([c66da68](https://github.com/JayRovacsek/nix-config/commit/c66da68a924d8cd07120a098db2fd0b83112c127))
- *(tooling)* Add tableau to work macos machines - ([95cd15a](https://github.com/JayRovacsek/nix-config/commit/95cd15a449a87a7f0cb0e731cb8aa6416750f8db))
- *(tooling)* Add git-cliff pre-commit check - ([25b9149](https://github.com/JayRovacsek/nix-config/commit/25b9149a83e27c6120ceb0b21ca45892506f18ed))
- *(tooling)* Replace prettierignore with package - ([6130434](https://github.com/JayRovacsek/nix-config/commit/6130434878c22e0319e5b721d97fa93ba173525e))
- *(tooling)* Exclude CHANGELOG from being automatically linted - ([3673f6b](https://github.com/JayRovacsek/nix-config/commit/3673f6b87a920c86fd908c9daca729e0904abb28))

### 🐛 Bug Fixes

- *(hydra)* Resolve git token to being readable for hydra services via group - ([ff76d36](https://github.com/JayRovacsek/nix-config/commit/ff76d3698aa29bcbe566f41d9a4d948ef8dc0d80))
- *(hydra)* Remove checks from hydra jobs - ([2e7233d](https://github.com/JayRovacsek/nix-config/commit/2e7233de66f7b4abd0ad655c02cc43ae51d849a1))
- *(linux)* Move gastly to home wireless network - ([951bc11](https://github.com/JayRovacsek/nix-config/commit/951bc114d351ab14ae84e76807a67463d0e94475))
- *(modules)* Resolve zfs support code for nextcloud - ([55308a5](https://github.com/JayRovacsek/nix-config/commit/55308a59285845c1ebf4fe814189b1f5b3879e17))
- *(modules)* Resolve issue with docker not evaluating zfs support correctly - ([d2184a7](https://github.com/JayRovacsek/nix-config/commit/d2184a707e6f92bb374ed2dfb2be574729da9891))
- *(modules)* Fix hydra github token being incorrectly created as root only - ([d315ea9](https://github.com/JayRovacsek/nix-config/commit/d315ea90e9f85a9bdcb0955f7284e043afbe4f3f))
- *(overlays)* Resolve git-cliff darwin build - ([4afa8d1](https://github.com/JayRovacsek/nix-config/commit/4afa8d1e9b3216954e57928896529521551f5e0a))
- *(tooling)* Add packages to conform known types - ([61b1591](https://github.com/JayRovacsek/nix-config/commit/61b1591184eed6b658121faf77639da6c28f9269))

### ⚙️ Miscellaneous Tasks

- *(packages)* Bump trdsql to v0.20.0 + disable checks - ([50bc014](https://github.com/JayRovacsek/nix-config/commit/50bc014630f5b35d0155670e8ac5c1c86c90ce97))
- *(tooling)* Bump flake inputs to utilise git-cliff from upstream - ([a275fc3](https://github.com/JayRovacsek/nix-config/commit/a275fc3e21c27f773f9ff22f4fb96a0660693005))
- *(tooling)* Reallocate tags to recent commits + tag init commit - ([23f69d5](https://github.com/JayRovacsek/nix-config/commit/23f69d5aab6dcc9f06f24d518065d4902e714427))

## [0.0.2](https://github.com/JayRovacsek/nix-config/compare/v0.0.1..v0.0.2) - 2024-02-20

### ⛰️  Features

- *(linux)* Move wigglytuff host from xfce to hyprland - ([f037eed](https://github.com/JayRovacsek/nix-config/commit/f037eed12cdba108ca0e696aa8d844fc86f190da))
- *(overlays)* Add git-cliff overlay - ([ac8cc9f](https://github.com/JayRovacsek/nix-config/commit/ac8cc9f71578e97909a93b81b412e89a3568dd03))
- *(tooling)* Add conform config file to gitignore - ([e151495](https://github.com/JayRovacsek/nix-config/commit/e15149593fa53c670703c5a060ed94bbc1206731))
- *(tooling)* Add generator for conform configuration - ([016a04a](https://github.com/JayRovacsek/nix-config/commit/016a04a1d9205eadb98f133b39953514cc4130b9))

### 🐛 Bug Fixes

- *(modules)* Resolve greetd including systemd logs - ([f6266cf](https://github.com/JayRovacsek/nix-config/commit/f6266cfc22ae09e52c247c42e09d1bba074b12eb))
- *(tooling)* Fix missing type of fix - ([6a80cb5](https://github.com/JayRovacsek/nix-config/commit/6a80cb53819d43f48ea658144731871c905b47ae))

### 📚 Documentation

- *(checks)* Generate initial changelog file - ([c327d38](https://github.com/JayRovacsek/nix-config/commit/c327d38cef5ec5b4b863cc16021046fff60c2d75))

### Release

- *(tooling)* Tag repository to better enable conventional commits - ([a5f7cb7](https://github.com/JayRovacsek/nix-config/commit/a5f7cb7da637be0e2757bfce44d7b754531ea117))

## [0.0.1](https://github.com/JayRovacsek/nix-config/compare/v0.0.0..v0.0.1) - 2024-02-11

### Add

- Bat, fzf, jq to HM - ([220832f](https://github.com/JayRovacsek/nix-config/commit/220832fe00630dc1be9b662d08f7ca1687490fea))

### Signed-off-by

- Dependabot[bot] <support@github.com> - ([de6509d](https://github.com/JayRovacsek/nix-config/commit/de6509dcd6e0cc5e9a8cde8c4412c0755effd0bb))
- Dependabot[bot] <support@github.com> - ([d210667](https://github.com/JayRovacsek/nix-config/commit/d21066730d801fbc6ebc724047e0d2f624dd04a8))
- Dependabot[bot] <support@github.com> - ([cc4eb64](https://github.com/JayRovacsek/nix-config/commit/cc4eb644c87809db5f3f7bc9c7ec6641d7233159))
- Dependabot[bot] <support@github.com> - ([796f890](https://github.com/JayRovacsek/nix-config/commit/796f890f024b059730bfc15adca497545f7dc3e0))

### Tree-wide

- Thunk use of nixpkgs to hopefully avoid expensive operations - ([9eb2a39](https://github.com/JayRovacsek/nix-config/commit/9eb2a39f79a6225a602726c03c53e2a4177e09fa))

### WIP

- Rework wireless secrets for gastly - ([d8c4526](https://github.com/JayRovacsek/nix-config/commit/d8c4526482e28413d11f632ccb00fcd73758440f))

### Protip

- It works rather than not :) - ([5258550](https://github.com/JayRovacsek/nix-config/commit/52585500be8f34314a070d3c44871c50127fab72))


