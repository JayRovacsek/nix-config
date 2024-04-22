## [unreleased]

### ⛰️  Features

- *(common)* Add basic nix topology diagram of configurations - ([6a27732](https://github.com/JayRovacsek/nix-config/commit/6a2773261989b04cb6ab9aa0d6b5a0bb023dd9fc))

- *(common)* Add vlan definitions to common code - ([6d515c9](https://github.com/JayRovacsek/nix-config/commit/6d515c9a485d31a3dd51b828fe0141deb446d991))

- *(flake)* Add nix-topology to inputs - ([e2b1703](https://github.com/JayRovacsek/nix-config/commit/e2b17036e6d8ead8ad419f48d3e11f8271012b47))

- *(linux)* Add grafana server root url to mr-mime - ([52ebe77](https://github.com/JayRovacsek/nix-config/commit/52ebe7730cc17d34f9eac51b0197a52673789e0a))

- *(linux)* Add nix-topology module to all nixos systems - ([9cdc214](https://github.com/JayRovacsek/nix-config/commit/9cdc214deb256b2d15c3eaccd13a3703cdaed886))

- *(modules)* Implement smartd module - ([cae7614](https://github.com/JayRovacsek/nix-config/commit/cae761465a98c19861e1bbb8668b9bc0c879a4d8))

- *(modules)* Implement nix-topology module - ([9cdc214](https://github.com/JayRovacsek/nix-config/commit/9cdc214deb256b2d15c3eaccd13a3703cdaed886))

- *(packages)* Re-introduce flask-security - ([ecd6dc7](https://github.com/JayRovacsek/nix-config/commit/ecd6dc7ec46c3e1440b8071f5b093690d2752cd3))

- *(packages)* Add topology to exported packages - ([dfff01f](https://github.com/JayRovacsek/nix-config/commit/dfff01ff3d208991af3e1acecfa530f4b6bafe6c))

- *(packages)* Implement pf and ub logos - ([0b598d7](https://github.com/JayRovacsek/nix-config/commit/0b598d78cff2d8deaf171acebdaed95f90f1742d))

### 🐛 Bug Fixes

- *(flake)* Change nix-topology input away from local dev - ([310343b](https://github.com/JayRovacsek/nix-config/commit/310343b09bfeaf0a1a7d762cdbe88153cdc9ba1e))

- *(home-manager-modules)* Change keepassxc default open behaviour - ([89a498c](https://github.com/JayRovacsek/nix-config/commit/89a498ca0b059cb08210f091abc46f79a742e864))

- *(home-manager-modules)* Correct screen positions for alakazam again - ([da9c289](https://github.com/JayRovacsek/nix-config/commit/da9c289fc8768d5e511b55f773944c015a013f63))

- *(linux)* Re-add blocky to magikarp for now due to custom mappings - ([abbaa1f](https://github.com/JayRovacsek/nix-config/commit/abbaa1ff2798ae6f7fa01ee090ba6a1e2998554d))

- *(linux)* Resolve issue with pipewire & i18n missing from gastly - ([e4152e4](https://github.com/JayRovacsek/nix-config/commit/e4152e45dd453c3c2778c887c2d0968faf47ff74))

- *(linux)* Remove redundant modules for slowpoke - ([bb1a223](https://github.com/JayRovacsek/nix-config/commit/bb1a2230ba1610a86046c100439e81c3bf9da1b5))

- *(modules)* Resolve hydra requiring new uris - ([0c13ff7](https://github.com/JayRovacsek/nix-config/commit/0c13ff79fbad92d59bdfb7064a96a18a4a4e0985))

- *(modules)* Acme requires list of extra domain names - ([0729897](https://github.com/JayRovacsek/nix-config/commit/072989790ce48dddf5b1ee781b950b50c20f2b85))

- *(modules)* Add both root and wildcard domains to acme configuration - ([200eac9](https://github.com/JayRovacsek/nix-config/commit/200eac9b7423f5d046a1d1d55a8386362e483076))

- *(modules)* Don't enforce headscale to run blocky also - ([20ae2b7](https://github.com/JayRovacsek/nix-config/commit/20ae2b7a0db13cad220b0e099267104671922d54))

- *(overlays)* Lexicographically sort inherit statement - ([9cdc214](https://github.com/JayRovacsek/nix-config/commit/9cdc214deb256b2d15c3eaccd13a3703cdaed886))

- *(packages)* Start resolving purple-ops issues - ([ecd6dc7](https://github.com/JayRovacsek/nix-config/commit/ecd6dc7ec46c3e1440b8071f5b093690d2752cd3))

- *(packages)* Resolve python-docx issue by removing override - ([ce7540e](https://github.com/JayRovacsek/nix-config/commit/ce7540e7577fc393d7a963f8d48d9a474750f770))

- *(packages)* Move some packages to the resource location - ([0b598d7](https://github.com/JayRovacsek/nix-config/commit/0b598d78cff2d8deaf171acebdaed95f90f1742d))

### 🚜 Refactor

- *(flake)* Move checks to main flake file - ([3156162](https://github.com/JayRovacsek/nix-config/commit/315616223dbfb5294256d811d376cc9d28267095))

- *(flake)* Remove redundant pname = name code - ([0b598d7](https://github.com/JayRovacsek/nix-config/commit/0b598d78cff2d8deaf171acebdaed95f90f1742d))

### 📚 Documentation

- *(flake)* Add topology doc to readme - ([dfff01f](https://github.com/JayRovacsek/nix-config/commit/dfff01ff3d208991af3e1acecfa530f4b6bafe6c))

### 🧪 Testing

- *(packages)* Remove topology from packages - ([0889862](https://github.com/JayRovacsek/nix-config/commit/08898627fdab8f7a62a03cd7471d8a2119666bef))
## [0.0.5](https://github.com/JayRovacsek/nix-config/compare/v0.0.4..v0.0.5) - 2024-04-05

### ⛰️  Features

- *(common)* Change loki definition to microvm - ([503be85](https://github.com/JayRovacsek/nix-config/commit/503be85c82ec3bbfd17f9cc1a0522a564a1b2a1e))

- *(common)* Add flaresolverr and openssh public keys to common - ([45aa879](https://github.com/JayRovacsek/nix-config/commit/45aa87909377c85100b39366e523075ec07b50fd))

- *(linux)* Add logging to igglybuff as litness test for microvms - ([ab6bd69](https://github.com/JayRovacsek/nix-config/commit/ab6bd691d209873074721c95981bb10248a62fd5))

- *(linux)* Enable logging on alakazam, dragonite and jigglypuff - ([4d7ba47](https://github.com/JayRovacsek/nix-config/commit/4d7ba47a95d692a90b8321ca223988ce748ef444))

- *(linux)* Add log macvlan to dragonite - ([503be85](https://github.com/JayRovacsek/nix-config/commit/503be85c82ec3bbfd17f9cc1a0522a564a1b2a1e))

- *(linux)* Add mr mime as logging microvm - ([503be85](https://github.com/JayRovacsek/nix-config/commit/503be85c82ec3bbfd17f9cc1a0522a564a1b2a1e))

- *(linux)* Add slowpoke as a new host (flaresolverr) - ([45aa879](https://github.com/JayRovacsek/nix-config/commit/45aa87909377c85100b39366e523075ec07b50fd))

- *(modules)* Implement telegraf for zfs metric data - ([908468e](https://github.com/JayRovacsek/nix-config/commit/908468e99b35e210a2c36e74c5fe394bc77cb44f))

- *(modules)* Uplift grafana agent module to start monitoring journey - ([4d7ba47](https://github.com/JayRovacsek/nix-config/commit/4d7ba47a95d692a90b8321ca223988ce748ef444))

- *(modules)* Add flaresolverr module - ([45aa879](https://github.com/JayRovacsek/nix-config/commit/45aa87909377c85100b39366e523075ec07b50fd))

- *(options)* Migrate network from lan to local as local domain - ([45aa879](https://github.com/JayRovacsek/nix-config/commit/45aa87909377c85100b39366e523075ec07b50fd))

- *(overlays)* Add sonarr overlay to resolve microvm breakage - ([45aa879](https://github.com/JayRovacsek/nix-config/commit/45aa87909377c85100b39366e523075ec07b50fd))
- Re-introduce generations as a module to all linux - ([bd7fefc](https://github.com/JayRovacsek/nix-config/commit/bd7fefc103e8c4c3d886fe21b8dc2afc53123415))


### 🐛 Bug Fixes

- *(home-manager-modules)* Resolve warnings related to zsh - ([bd73ac0](https://github.com/JayRovacsek/nix-config/commit/bd73ac04d44787b62a1721205d8d871cf66b8741))

- *(home-manager-modules)* Resolve warnings related to nixvim - ([077475d](https://github.com/JayRovacsek/nix-config/commit/077475d2eb8049e0daf9e22b8411ae69f42fe794))

- *(home-manager-modules)* Correct hyprland window config on alakazam - ([c9db6c6](https://github.com/JayRovacsek/nix-config/commit/c9db6c66572a92057b5ca5a0fb3ba5ae7b241a5e))

- *(home-manager-modules)* Resolve firefox custom code search shortcut - ([6262682](https://github.com/JayRovacsek/nix-config/commit/626268297ac071753b6596a39708760004786a44))

- *(linux)* Reduce ram allocated to nidoking; not required with zfs fixes - ([d9b5190](https://github.com/JayRovacsek/nix-config/commit/d9b5190fd0d059305816b9d62a869be9dfea3ee8))

- *(linux)* Add services to mr-mime - ([dd78a6f](https://github.com/JayRovacsek/nix-config/commit/dd78a6ff79d607a4239a16fca3cb89907276b5c1))

- *(linux)* Remove dead zfs stores from dragonite - ([1b73bec](https://github.com/JayRovacsek/nix-config/commit/1b73bec10e135fc6f10858ca05a454c0b93fe69f))

- *(linux)* Add magikarp back to dragonite - ([c93d9db](https://github.com/JayRovacsek/nix-config/commit/c93d9dbe26d14fa3b65ae1ec27fc6a846f88304f))

- *(linux)* Remove password ssh configuration from microvms - ([503be85](https://github.com/JayRovacsek/nix-config/commit/503be85c82ec3bbfd17f9cc1a0522a564a1b2a1e))

- *(linux)* Remove password ssh auth from microvms - ([45aa879](https://github.com/JayRovacsek/nix-config/commit/45aa87909377c85100b39366e523075ec07b50fd))

- *(modules)* Revert mjs code from nginx - ([d9b5190](https://github.com/JayRovacsek/nix-config/commit/d9b5190fd0d059305816b9d62a869be9dfea3ee8))

- *(modules)* Expose ports for prometheus and loki - ([dd78a6f](https://github.com/JayRovacsek/nix-config/commit/dd78a6ff79d607a4239a16fca3cb89907276b5c1))

- *(modules)* Resolve microvm host issues related to macvtap state - ([a7d2eeb](https://github.com/JayRovacsek/nix-config/commit/a7d2eeb9500f8c1b482af219d0bd446e392d6239))

- *(modules)* Add ffmpeg to nextcloud module to enable media conversion - ([22c32be](https://github.com/JayRovacsek/nix-config/commit/22c32be3b373aae166ed60a3969478191d2a8d33))

- *(modules)* Remove power settings and modify systemd sleep for microvms - ([100444a](https://github.com/JayRovacsek/nix-config/commit/100444a458d9b06f7f9d09b7cce909f849101194))

- *(modules)* Force palworld to start when ready - ([100a2d6](https://github.com/JayRovacsek/nix-config/commit/100a2d69d18960849d9a45755ca46a5b15fbe745))

- *(modules)* Resolve issues related to nextcloud configuration - ([3f44d2a](https://github.com/JayRovacsek/nix-config/commit/3f44d2a23c084f9ca74eca56c9f275140d79ea01))

- *(modules)* Reduce systemd configuration limit - ([bd7fefc](https://github.com/JayRovacsek/nix-config/commit/bd7fefc103e8c4c3d886fe21b8dc2afc53123415))

- *(modules)* Resolve headscale migration issue re; acls - ([c0ece2c](https://github.com/JayRovacsek/nix-config/commit/c0ece2c05908834158a8a192faa91e6378f550f8))

- *(modules)* Correct headscale to match upstream changes of tailnet -> user - ([503be85](https://github.com/JayRovacsek/nix-config/commit/503be85c82ec3bbfd17f9cc1a0522a564a1b2a1e))

- *(modules)* Add allowed uri for hydra - ([503be85](https://github.com/JayRovacsek/nix-config/commit/503be85c82ec3bbfd17f9cc1a0522a564a1b2a1e))

- *(options)* Headscale options alignment with upstream tailnet -> user - ([503be85](https://github.com/JayRovacsek/nix-config/commit/503be85c82ec3bbfd17f9cc1a0522a564a1b2a1e))

- *(options)* Remove custom tailscale options - they appear to be resolved upstream - ([45aa879](https://github.com/JayRovacsek/nix-config/commit/45aa87909377c85100b39366e523075ec07b50fd))

- *(packages)* Resolve xattr dependency issues for dfvfs and plaso - ([66147c1](https://github.com/JayRovacsek/nix-config/commit/66147c138c672d80689fcada93d77db1bdf3c795))

- *(packages)* Update battlenet prefill & resolve moved submodule csproj file - ([c03cbff](https://github.com/JayRovacsek/nix-config/commit/c03cbff9ceed5f557133f72dcc8a64880280c76f))

- *(packages)* Resolve builds for steam and epic prefill - ([e28fb77](https://github.com/JayRovacsek/nix-config/commit/e28fb77c72e9c25a8080dfb65901af8d4baac8b6))

- *(packages)* Ditto transform points to the main branch of config repo now - ([d972634](https://github.com/JayRovacsek/nix-config/commit/d972634faa723b81a5de4534855cb22351a9ec23))

- *(tooling)* Change pre-commit for trufflehog to only linux - ([5fef734](https://github.com/JayRovacsek/nix-config/commit/5fef734110488a0ac50376ab5911b655a3e0d124))

- *(tooling)* Correct use of remote (git) in generating conform yaml - ([03e598c](https://github.com/JayRovacsek/nix-config/commit/03e598cc687190491e77cb2f8a2b2ca19c507a4e))

### 🚜 Refactor

- *(common,tooling,linux)* Move media uid/gids into common, remove modules - ([b4e5a3c](https://github.com/JayRovacsek/nix-config/commit/b4e5a3cbac2a5301c74733cbd22fdb79b84a393f))

- *(home-manager-modules)* Clean up zsh module - ([bd73ac0](https://github.com/JayRovacsek/nix-config/commit/bd73ac04d44787b62a1721205d8d871cf66b8741))

- *(overlays)* Remove all python overlays as they are no longer required - ([3cd203e](https://github.com/JayRovacsek/nix-config/commit/3cd203e37239409dd4ebf1be246a90fcd5139c90))

- *(packages)* Remove use of name across remaining packages - ([60091f2](https://github.com/JayRovacsek/nix-config/commit/60091f2822226b6dfdbc7554f27bb2c7e9de022d))

- *(packages)* Make all python packages consistent in order - ([3cd203e](https://github.com/JayRovacsek/nix-config/commit/3cd203e37239409dd4ebf1be246a90fcd5139c90))

- *(shells)* Minor refactor on shell - ([3891046](https://github.com/JayRovacsek/nix-config/commit/3891046a137c8a3463f9250f22c141e9dfd70494))
## [0.0.4](https://github.com/JayRovacsek/nix-config/compare/v0.0.3..v0.0.4) - 2024-03-24

### ⛰️  Features

- *(home-manager-modules)* Expose hm-modules via flake attribute at top level - ([8160775](https://github.com/JayRovacsek/nix-config/commit/8160775c74a725f4f698747c1b480c18fb718588))

- *(linux)* Re-introduce auto-updates to dragonite - ([efcc88c](https://github.com/JayRovacsek/nix-config/commit/efcc88cef665df90e8ca5a051cc17cb74e53fd7e))

- *(linux)* Remove update flake from microvms - ([c44b4a0](https://github.com/JayRovacsek/nix-config/commit/c44b4a0fd252e814d3b1fe01bf69ff1a621aa908))

- *(linux)* Change microvms to restart if changed on host - ([c44b4a0](https://github.com/JayRovacsek/nix-config/commit/c44b4a0fd252e814d3b1fe01bf69ff1a621aa908))

- *(linux)* Move to stable updateFlake ref - ([aa8adf4](https://github.com/JayRovacsek/nix-config/commit/aa8adf4c27280813fc405560b38df2463086bcca))

- *(linux)* Change cloyster to waybar - ([0b01017](https://github.com/JayRovacsek/nix-config/commit/0b0101739b1754df8d69e6f93e848c7cc59c8d5b))

- *(tooling)* Remove checks run - working on this elsewhere - ([c18e23e](https://github.com/JayRovacsek/nix-config/commit/c18e23e4de826bf07cfc171c9baeb8c66269bfbd))

### 🐛 Bug Fixes

- *(darwin)* Resolve darwin config issues - ([9e4a063](https://github.com/JayRovacsek/nix-config/commit/9e4a06358189f466078b0b8d22dbb6fd2cedcc03))

- *(home-manager-modules)* Resolve firefox bookmark issue with github - ([fa99493](https://github.com/JayRovacsek/nix-config/commit/fa994939199c78f6729989c425a84526d086eab2))

- *(home-manager-modules)* Add editor session variable to nixvim - ([b7dcaa5](https://github.com/JayRovacsek/nix-config/commit/b7dcaa515e4b026183968f4720059b18b73b2ac8))

- *(lib)* Fix use of extraSpecialArgs for home manager - ([31a152f](https://github.com/JayRovacsek/nix-config/commit/31a152f0963d39662d78cc6cdab523520eb0007e))

- *(linux)* Resolve issue with dragonite missing i18n settings after refactor - ([efcc88c](https://github.com/JayRovacsek/nix-config/commit/efcc88cef665df90e8ca5a051cc17cb74e53fd7e))

- *(linux)* Resolve incorrect disable-assertions reference - ([51dde15](https://github.com/JayRovacsek/nix-config/commit/51dde155cd463c6c0cad8843f056d360c06bfc21))

- *(linux)* Add uids/gids to dragonite - ([e4e4002](https://github.com/JayRovacsek/nix-config/commit/e4e40028db64aefd1f6088c7d76a0afc1f9e9299))

- *(linux)* Resolve lack of specialArgs on images - ([ff9115d](https://github.com/JayRovacsek/nix-config/commit/ff9115dd7d08bf523cada8079d900346ba47d4e3))

- *(linux)* Resolve incorrect use of home-manager-modules on wigglytuff - ([1dbbf32](https://github.com/JayRovacsek/nix-config/commit/1dbbf3264f8c2aaa226908d6f3c8426ec9528ce3))

- *(options)* Move network to local - ([5fd2dd1](https://github.com/JayRovacsek/nix-config/commit/5fd2dd1e301cb7ca6ab48df5b0bb208ecdf84205))

- *(tooling)* Remove checks configuration - ([3502cb3](https://github.com/JayRovacsek/nix-config/commit/3502cb3587f17aaaf0d1e71177c44ade1aee6e52))

### 🚜 Refactor

- *(apps)* Remove act app - ([b6c40d3](https://github.com/JayRovacsek/nix-config/commit/b6c40d325f73503ef9042fd89c1924cf70d423d4))

- *(darwin)* Rename merged user config to user-configs - ([5ca9a4e](https://github.com/JayRovacsek/nix-config/commit/5ca9a4ef54da9cd1846f20231cc3cf53502fe2eb))

- *(darwin)* Remove use of flake options - ([8160775](https://github.com/JayRovacsek/nix-config/commit/8160775c74a725f4f698747c1b480c18fb718588))

- *(flake)* Remove home manager configurations - ([5ca9a4e](https://github.com/JayRovacsek/nix-config/commit/5ca9a4ef54da9cd1846f20231cc3cf53502fe2eb))

- *(flake)* Refactor modules and hm-modules to use self in specialArgs - ([8160775](https://github.com/JayRovacsek/nix-config/commit/8160775c74a725f4f698747c1b480c18fb718588))

- *(home-manager-modules)* Remove use of flake throughout - ([8160775](https://github.com/JayRovacsek/nix-config/commit/8160775c74a725f4f698747c1b480c18fb718588))

- *(linux)* Rename merged user config to user-configs - ([5ca9a4e](https://github.com/JayRovacsek/nix-config/commit/5ca9a4ef54da9cd1846f20231cc3cf53502fe2eb))

- *(linux)* Remove use of flake options - ([8160775](https://github.com/JayRovacsek/nix-config/commit/8160775c74a725f4f698747c1b480c18fb718588))

- *(modules)* Remove use of flake throughout - ([8160775](https://github.com/JayRovacsek/nix-config/commit/8160775c74a725f4f698747c1b480c18fb718588))
- Remove all modules files in favour of single file - ([cc424c5](https://github.com/JayRovacsek/nix-config/commit/cc424c53972aea0ee1f5cc24b3f2fae61d4de09b))


### 🧪 Testing

- *(linux)* Swap alakazam back to waybar for now - ([b6c40d3](https://github.com/JayRovacsek/nix-config/commit/b6c40d325f73503ef9042fd89c1924cf70d423d4))
## [0.0.3](https://github.com/JayRovacsek/nix-config/compare/v0.0.2..v0.0.3) - 2024-03-22

### ⛰️  Features

- *(common)* Add more definitions to networking services - ([5f7700c](https://github.com/JayRovacsek/nix-config/commit/5f7700c810963a1ccef994489dc237904a7783f1))

- *(darwin)* Add trdsql package back to victreebel - ([ca18a44](https://github.com/JayRovacsek/nix-config/commit/ca18a449d0da38629dfe24e5627ce5e4eb3bed16))

- *(flake)* Add nix-github-actions input - ([6f59bb1](https://github.com/JayRovacsek/nix-config/commit/6f59bb1d8eefe285c00b3223305a8a22e3218f53))

- *(flake)* Enable system agnostic overlays to be utilised in flake - ([25b9149](https://github.com/JayRovacsek/nix-config/commit/25b9149a83e27c6120ceb0b21ca45892506f18ed))

- *(home-manager-modules)* Change from neovim-flake to nixvim - ([d9cb899](https://github.com/JayRovacsek/nix-config/commit/d9cb8999b83b23f0554d5df42ac8399be5e10259))

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

- *(home-manager-modules)* Update ags module to reflect new branch in ags-config - ([d3ed33e](https://github.com/JayRovacsek/nix-config/commit/d3ed33ef9b99b5f1691279f762c50d8f51627422))

- *(hydra)* Add numtide devshell to allowed uris - ([baace17](https://github.com/JayRovacsek/nix-config/commit/baace179453734de90f47f2ab560eb2de0664146))

- *(hydra)* Add base16 to allowed uris - ([6149c48](https://github.com/JayRovacsek/nix-config/commit/6149c48e7552dc92280596404627c88d4075c16c))

- *(hydra)* Resolve git token to being readable for hydra services via group - ([ff76d36](https://github.com/JayRovacsek/nix-config/commit/ff76d3698aa29bcbe566f41d9a4d948ef8dc0d80))

- *(hydra)* Remove checks from hydra jobs - ([2e7233d](https://github.com/JayRovacsek/nix-config/commit/2e7233de66f7b4abd0ad655c02cc43ae51d849a1))

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

- *(overlays)* Resolve git-cliff darwin build - ([4afa8d1](https://github.com/JayRovacsek/nix-config/commit/4afa8d1e9b3216954e57928896529521551f5e0a))

- *(packages)* Mark backgroundremover as broken - ([5860ef6](https://github.com/JayRovacsek/nix-config/commit/5860ef6b5f5e455a1cbbeb4cf2cfe1f8c58a56c2))

- *(packages)* Remove flask-security & security-too overlays/packages - ([49def46](https://github.com/JayRovacsek/nix-config/commit/49def46c1a58d5989619a7a368c034d87021d8cc))

- *(secrets)* Correct terraform api secret - ([72048dc](https://github.com/JayRovacsek/nix-config/commit/72048dc74e40d6d86e8571bd2aca596ce089acc8))

- *(tooling)* Add packages to conform known types - ([61b1591](https://github.com/JayRovacsek/nix-config/commit/61b1591184eed6b658121faf77639da6c28f9269))

### 🚜 Refactor

- *(apps)* Remove act app - ([3e900ab](https://github.com/JayRovacsek/nix-config/commit/3e900abcba82611d33094f1917bc5f09a572167d))

- *(home-manager-modules)* Implement mopidy in hm rather than system - ([d3ed33e](https://github.com/JayRovacsek/nix-config/commit/d3ed33ef9b99b5f1691279f762c50d8f51627422))

### 📚 Documentation

- *(hydra)* Add comments to hydra required allowed uris - ([8ccf002](https://github.com/JayRovacsek/nix-config/commit/8ccf002f3c6627e92c30b16c4f31e6dd786b6f41))

### 🧪 Testing

- *(linux)* Swap alakazam back to waybar for now - ([3e900ab](https://github.com/JayRovacsek/nix-config/commit/3e900abcba82611d33094f1917bc5f09a572167d))
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

