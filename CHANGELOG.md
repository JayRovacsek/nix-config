## [unreleased]

### ⛰️  Features

- *(common)* Add more definitions to networking services - ([5f7700c](https://github.com/JayRovacsek/nix-config/commit/5f7700c810963a1ccef994489dc237904a7783f1))

- *(darwin)* Add trdsql package back to victreebel - ([ca18a44](https://github.com/JayRovacsek/nix-config/commit/ca18a449d0da38629dfe24e5627ce5e4eb3bed16))

- *(flake)* Add nix-github-actions input - ([6f59bb1](https://github.com/JayRovacsek/nix-config/commit/6f59bb1d8eefe285c00b3223305a8a22e3218f53))

- *(flake)* Enable system agnostic overlays to be utilised in flake - ([25b9149](https://github.com/JayRovacsek/nix-config/commit/25b9149a83e27c6120ceb0b21ca45892506f18ed))

- *(home-manager-modules)* Expose hm-modules via flake attribute at top level - ([8160775](https://github.com/JayRovacsek/nix-config/commit/8160775c74a725f4f698747c1b480c18fb718588))

- *(home-manager-modules)* Change from neovim-flake to nixvim - ([d9cb899](https://github.com/JayRovacsek/nix-config/commit/d9cb8999b83b23f0554d5df42ac8399be5e10259))

- *(linux)* Move to stable updateFlake ref - ([aa8adf4](https://github.com/JayRovacsek/nix-config/commit/aa8adf4c27280813fc405560b38df2463086bcca))

- *(linux)* Change cloyster to waybar - ([0b01017](https://github.com/JayRovacsek/nix-config/commit/0b0101739b1754df8d69e6f93e848c7cc59c8d5b))

- *(linux)* Add upower to alakazam for testing - ([d3ed33e](https://github.com/JayRovacsek/nix-config/commit/d3ed33ef9b99b5f1691279f762c50d8f51627422))

- *(linux)* Move gastly to greetd, remove docker + pipewire - ([a364d66](https://github.com/JayRovacsek/nix-config/commit/a364d665db80b614f187f0ee009194f501e644f5))

- *(linux)* Add zfs dataset to dragonite (osts) - ([004159b](https://github.com/JayRovacsek/nix-config/commit/004159b1c29647c886ae9a7db567439962492429))

- *(modules)* Implement upower module to utilise in ags - ([757e6f8](https://github.com/JayRovacsek/nix-config/commit/757e6f8290ea62aa63e00d7b21bdf00937143efa))

- *(modules)* Add blocky dashboard to grafana - ([f2fb944](https://github.com/JayRovacsek/nix-config/commit/f2fb944fb68faf346e067a85f7252ec7889a259d))

- *(modules)* Enable reporting for blocky module - ([eb9f59d](https://github.com/JayRovacsek/nix-config/commit/eb9f59d1818f996010a1819690b100fd81f2baee))

- *(modules)* Add common network definitions to grafana-agent module - ([775f13f](https://github.com/JayRovacsek/nix-config/commit/775f13f4fdb3d2665dbd0d61ef653ca34a63619f))

- *(modules)* Order grafana module, add settings to allow network access - ([8449937](https://github.com/JayRovacsek/nix-config/commit/84499379d74f48ffd2f55fb34a23528556de2c81))

- *(modules)* Create basic prometheus module - ([5a784cf](https://github.com/JayRovacsek/nix-config/commit/5a784cfb85ae9dd309b3305ce39e7ae71ccd1e94))

- *(modules)* Enable nix binary cache on linux-builder - ([5466cdc](https://github.com/JayRovacsek/nix-config/commit/5466cdce52f072e441f0d6000f55ac7e6f8cef1f))

- *(modules)* Add linux builder to darwin settings - ([4b2e4f9](https://github.com/JayRovacsek/nix-config/commit/4b2e4f9f17b3711915f1cc17b4ddfe8725d7a400))

- *(options)* Enable emulated systems for linux-builder - ([5466cdc](https://github.com/JayRovacsek/nix-config/commit/5466cdce52f072e441f0d6000f55ac7e6f8cef1f))

- *(overlays)* Move overlay system binds to common space + remove from package-sets - ([25b9149](https://github.com/JayRovacsek/nix-config/commit/25b9149a83e27c6120ceb0b21ca45892506f18ed))

- *(packages)* Add wireplumber configuration to text packages - ([062304b](https://github.com/JayRovacsek/nix-config/commit/062304b7e547cbffd94302ac6de02c3685ae386f))

- *(packages)* Implement prettierignore config as a package - ([305ef53](https://github.com/JayRovacsek/nix-config/commit/305ef53311a60df3997652c668f331b1f25ca313))

- *(tooling)* Remove checks run - working on this elsewhere - ([c18e23e](https://github.com/JayRovacsek/nix-config/commit/c18e23e4de826bf07cfc171c9baeb8c66269bfbd))

- *(tooling)* Implement gh actions check via nix-github-actions - ([fe0f91b](https://github.com/JayRovacsek/nix-config/commit/fe0f91beb1a3ba5a579f2af4901c87a4fd56e499))

- *(tooling)* Move conform generator to tooling app - ([7da9c17](https://github.com/JayRovacsek/nix-config/commit/7da9c177b236765a87672543345e287ff9ae1ec5))

- *(tooling)* Implement typos configuration app - ([7da9c17](https://github.com/JayRovacsek/nix-config/commit/7da9c177b236765a87672543345e287ff9ae1ec5))

- *(tooling)* Implement cliff configuration app - ([7da9c17](https://github.com/JayRovacsek/nix-config/commit/7da9c177b236765a87672543345e287ff9ae1ec5))

- *(tooling)* Implement generate all configs app - ([7da9c17](https://github.com/JayRovacsek/nix-config/commit/7da9c177b236765a87672543345e287ff9ae1ec5))

- *(tooling)* Remove configuration files from repository - ([51d21b1](https://github.com/JayRovacsek/nix-config/commit/51d21b11da0bc1d5a4ddd998dda5fc2776cf2416))

- *(tooling)* Add cliff.toml file to ensure consistent changelog generation - ([c66da68](https://github.com/JayRovacsek/nix-config/commit/c66da68a924d8cd07120a098db2fd0b83112c127))

- *(tooling)* Add tableau to work macos machines - ([95cd15a](https://github.com/JayRovacsek/nix-config/commit/95cd15a449a87a7f0cb0e731cb8aa6416750f8db))

- *(tooling)* Add git-cliff pre-commit check - ([25b9149](https://github.com/JayRovacsek/nix-config/commit/25b9149a83e27c6120ceb0b21ca45892506f18ed))

- *(tooling)* Replace prettierignore with package - ([6130434](https://github.com/JayRovacsek/nix-config/commit/6130434878c22e0319e5b721d97fa93ba173525e))

- *(tooling)* Exclude CHANGELOG from being automatically linted - ([3673f6b](https://github.com/JayRovacsek/nix-config/commit/3673f6b87a920c86fd908c9daca729e0904abb28))

### 🐛 Bug Fixes

- *(darwin)* Resolve darwin config issues - ([9e4a063](https://github.com/JayRovacsek/nix-config/commit/9e4a06358189f466078b0b8d22dbb6fd2cedcc03))

- *(home-manager-modules)* Add editor session variable to nixvim - ([b7dcaa5](https://github.com/JayRovacsek/nix-config/commit/b7dcaa515e4b026183968f4720059b18b73b2ac8))

- *(home-manager-modules)* Update ags module to reflect new branch in ags-config - ([d3ed33e](https://github.com/JayRovacsek/nix-config/commit/d3ed33ef9b99b5f1691279f762c50d8f51627422))

- *(hydra)* Add numtide devshell to allowed uris - ([baace17](https://github.com/JayRovacsek/nix-config/commit/baace179453734de90f47f2ab560eb2de0664146))

- *(hydra)* Add base16 to allowed uris - ([6149c48](https://github.com/JayRovacsek/nix-config/commit/6149c48e7552dc92280596404627c88d4075c16c))

- *(hydra)* Resolve git token to being readable for hydra services via group - ([ff76d36](https://github.com/JayRovacsek/nix-config/commit/ff76d3698aa29bcbe566f41d9a4d948ef8dc0d80))

- *(hydra)* Remove checks from hydra jobs - ([2e7233d](https://github.com/JayRovacsek/nix-config/commit/2e7233de66f7b4abd0ad655c02cc43ae51d849a1))

- *(lib)* Fix use of extraSpecialArgs for home manager - ([31a152f](https://github.com/JayRovacsek/nix-config/commit/31a152f0963d39662d78cc6cdab523520eb0007e))

- *(linux)* Move updateFlake of microvms to stable ref - ([6a6b1c1](https://github.com/JayRovacsek/nix-config/commit/6a6b1c1bed833709573582d2dbc39334fc421587))

- *(linux)* Resolve sonarr dependencies on x11 - ([3b228f6](https://github.com/JayRovacsek/nix-config/commit/3b228f613b63df01569f89dafa6a7ddac33e070d))

- *(linux)* Remove grub from t2 host (requires systemd) - ([f474124](https://github.com/JayRovacsek/nix-config/commit/f47412477c8a1b7b21a6afafa8eb376ce05110e4))

- *(linux)* Remove pipewire from hosts temporarily - ([49def46](https://github.com/JayRovacsek/nix-config/commit/49def46c1a58d5989619a7a368c034d87021d8cc))

- *(linux)* Move gastly to home wireless network - ([951bc11](https://github.com/JayRovacsek/nix-config/commit/951bc114d351ab14ae84e76807a67463d0e94475))

- *(modules)* Resolve hydra eval issues - ([a3f0ba6](https://github.com/JayRovacsek/nix-config/commit/a3f0ba670cc4a6139d0f1d8fff4ac190d01eaff6))

- *(modules)* Fix pipewire module to resolve 24.05 breakage - ([062304b](https://github.com/JayRovacsek/nix-config/commit/062304b7e547cbffd94302ac6de02c3685ae386f))

- *(modules)* Remove deprecated wireplumber config - ([ed05243](https://github.com/JayRovacsek/nix-config/commit/ed05243f4b630d860378fa3126b60990bddb9be2))

- *(modules)* Resolve eval error - ([4cf0320](https://github.com/JayRovacsek/nix-config/commit/4cf0320c34788f5aeb0078483b7e8ef8dd503a7c))

- *(modules)* Resolve zfs support code for nextcloud - ([55308a5](https://github.com/JayRovacsek/nix-config/commit/55308a59285845c1ebf4fe814189b1f5b3879e17))

- *(modules)* Resolve issue with docker not evaluating zfs support correctly - ([d2184a7](https://github.com/JayRovacsek/nix-config/commit/d2184a707e6f92bb374ed2dfb2be574729da9891))

- *(modules)* Fix hydra github token being incorrectly created as root only - ([d315ea9](https://github.com/JayRovacsek/nix-config/commit/d315ea90e9f85a9bdcb0955f7284e043afbe4f3f))

- *(modules)* Remove non-loki code from loki module - ([3adec3b](https://github.com/JayRovacsek/nix-config/commit/3adec3b28d03f74f2dd78c17fb34fad60686cbc3))

- *(options)* Move network to local - ([5fd2dd1](https://github.com/JayRovacsek/nix-config/commit/5fd2dd1e301cb7ca6ab48df5b0bb208ecdf84205))

- *(overlays)* Resolve git-cliff darwin build - ([4afa8d1](https://github.com/JayRovacsek/nix-config/commit/4afa8d1e9b3216954e57928896529521551f5e0a))

- *(packages)* Mark backgroundremover as broken - ([5860ef6](https://github.com/JayRovacsek/nix-config/commit/5860ef6b5f5e455a1cbbeb4cf2cfe1f8c58a56c2))

- *(packages)* Remove flask-security & security-too overlays/packages - ([49def46](https://github.com/JayRovacsek/nix-config/commit/49def46c1a58d5989619a7a368c034d87021d8cc))

- *(secrets)* Correct terraform api secret - ([72048dc](https://github.com/JayRovacsek/nix-config/commit/72048dc74e40d6d86e8571bd2aca596ce089acc8))

- *(tooling)* Add packages to conform known types - ([61b1591](https://github.com/JayRovacsek/nix-config/commit/61b1591184eed6b658121faf77639da6c28f9269))

### 🚜 Refactor

- *(apps)* Remove act app - ([3e900ab](https://github.com/JayRovacsek/nix-config/commit/3e900abcba82611d33094f1917bc5f09a572167d))

- *(apps)* Remove act app - ([b6c40d3](https://github.com/JayRovacsek/nix-config/commit/b6c40d325f73503ef9042fd89c1924cf70d423d4))

- *(darwin)* Remove use of flake options - ([8160775](https://github.com/JayRovacsek/nix-config/commit/8160775c74a725f4f698747c1b480c18fb718588))

- *(flake)* Refactor modules and hm-modules to use self in specialArgs - ([8160775](https://github.com/JayRovacsek/nix-config/commit/8160775c74a725f4f698747c1b480c18fb718588))

- *(home-manager-modules)* Remove use of flake throughout - ([8160775](https://github.com/JayRovacsek/nix-config/commit/8160775c74a725f4f698747c1b480c18fb718588))

- *(home-manager-modules)* Implement mopidy in hm rather than system - ([d3ed33e](https://github.com/JayRovacsek/nix-config/commit/d3ed33ef9b99b5f1691279f762c50d8f51627422))

- *(linux)* Remove use of flake options - ([8160775](https://github.com/JayRovacsek/nix-config/commit/8160775c74a725f4f698747c1b480c18fb718588))

- *(modules)* Remove use of flake throughout - ([8160775](https://github.com/JayRovacsek/nix-config/commit/8160775c74a725f4f698747c1b480c18fb718588))

### 📚 Documentation

- *(hydra)* Add comments to hydra required allowed uris - ([8ccf002](https://github.com/JayRovacsek/nix-config/commit/8ccf002f3c6627e92c30b16c4f31e6dd786b6f41))

### 🧪 Testing

- *(linux)* Swap alakazam back to waybar for now - ([3e900ab](https://github.com/JayRovacsek/nix-config/commit/3e900abcba82611d33094f1917bc5f09a572167d))

- *(linux)* Swap alakazam back to waybar for now - ([b6c40d3](https://github.com/JayRovacsek/nix-config/commit/b6c40d325f73503ef9042fd89c1924cf70d423d4))
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

