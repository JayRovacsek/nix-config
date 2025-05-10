
## [unreleased]

### ⛰️  Features

- *(home-manager-modules)* Augment zsh plugins - ([f0ffa58](https://github.com/JayRovacsek/nix-config/commit/f0ffa58a9835874aa1faeffba69785b7b21ae6cc))

- *(hydra,linux,modules)* Update lix inputs and move to lix hydra - ([f866e9c](https://github.com/JayRovacsek/nix-config/commit/f866e9c2c0f3c1f87fe64a5a6bf337b83b970d9f))

- *(iac)* Add oscalnix and move talk to public - ([d743805](https://github.com/JayRovacsek/nix-config/commit/d743805e6dfcab9cf60bf15b1a2a8f31f3f0bd12))

- *(iac)* Add untitled talk to repositories - ([a2ed006](https://github.com/JayRovacsek/nix-config/commit/a2ed00665e4b91315274395aee8edcf970b84e28))

- *(iac)* Sync github with nix definitions - ([004080e](https://github.com/JayRovacsek/nix-config/commit/004080eb5087360894440781906864059705901a))

- *(lib)* Add capability to override values within repository settings - ([167cc6d](https://github.com/JayRovacsek/nix-config/commit/167cc6db0fc85a5ee49240e11558e190df209518))

- *(linux)* Disable porygon for now - ([4422355](https://github.com/JayRovacsek/nix-config/commit/442235552ae08e26130cb0bb9c317ac076099f65))

- *(modules)* Re-add jellyfin intro skipper overlay - ([7dfcc4e](https://github.com/JayRovacsek/nix-config/commit/7dfcc4e47ab18a857cad59d456e5774768ee94a0))

### 🐛 Bug Fixes

- *(home-manager-modules)* Resolve removed lsd option - ([0a6c076](https://github.com/JayRovacsek/nix-config/commit/0a6c076e2f89fc7fa07a75c749be2a645fbaab32))

- *(home-manager-modules)* Move to new alloy service option - ([ddac982](https://github.com/JayRovacsek/nix-config/commit/ddac98288c372a3a506a6ad728148dc1ca32d289))

- *(home-manager-modules)* Don't set timezones explicitly - ([c5b294e](https://github.com/JayRovacsek/nix-config/commit/c5b294e96f41fd78f9e1f0942089e2cfcd742792))

- *(lib)* Ensure github  default branches also use overrides where possible - ([59513b8](https://github.com/JayRovacsek/nix-config/commit/59513b8326766ae877b4a28948332cadfdbbb673))

- *(modules)* Remove recognize from nextcloud apps temporarily as it is broken - ([abfb2e9](https://github.com/JayRovacsek/nix-config/commit/abfb2e9edbd6fa4494b6808bc15ded0fa842c4c7))

- *(modules,options)* Handle for new sonarr settings option for http port - ([7668c3f](https://github.com/JayRovacsek/nix-config/commit/7668c3feec5c9549d853f70f19de173c34c3d0b8))

- *(modules,packages)* Remove eww-wayland - ([f5159f5](https://github.com/JayRovacsek/nix-config/commit/f5159f5fcad7b5d05d684014b411cc47636c8829))

- *(packages)* Remove action-validator as it is packaged upstream nowadays - ([d4d7b2b](https://github.com/JayRovacsek/nix-config/commit/d4d7b2b12b134b9719cc87fee217836aac23479a))

### 🚜 Refactor

- *(modules)* Update steam to include proton-ge and handle wayland better - ([8b1efdb](https://github.com/JayRovacsek/nix-config/commit/8b1efdb4b066f5367f5a754b714b13ee45de462d))

- *(modules)* Migrate grafana agent to alloy - ([8d646a6](https://github.com/JayRovacsek/nix-config/commit/8d646a648d095c136d604d4f3508695e1ca500ee))
## [0.1.0](https://github.com/JayRovacsek/nix-config/compare/v0.0.9..v0.1.0) - 2025-03-22

### ⛰️  Features

- *(common)* Add ivysaur and wartortle configs to host map - ([01ac09f](https://github.com/JayRovacsek/nix-config/commit/01ac09f2cf9661539708dbbe6369a64548088492))

- *(common)* Add bazarr config entry - ([7f048ff](https://github.com/JayRovacsek/nix-config/commit/7f048ffca34bd29d5b5a2b11b6aba7081d96684c))

- *(home-manager-modules)* Add nur hm module - ([e5bb102](https://github.com/JayRovacsek/nix-config/commit/e5bb102282979eb4829c947ddbeb1bf33a9dd357))

- *(home-manager-modules)* Handle lutris default install location - ([62501d1](https://github.com/JayRovacsek/nix-config/commit/62501d19daedaeae05eee08b5e27498948690a37))

- *(home-manager-modules,lib)* Implement ghostty module - ([6594b3d](https://github.com/JayRovacsek/nix-config/commit/6594b3de5eeaae499adf412ab33ada0a0606ae24))

- *(linux)* Remove rpi5 from exposed full configs until sd image is resolved - ([d908976](https://github.com/JayRovacsek/nix-config/commit/d908976fa82da29655b227494ac52450b6aa77a3))

- *(linux)* Add blocky and nix-topology to rpi5s - ([8bc4f96](https://github.com/JayRovacsek/nix-config/commit/8bc4f96a37179322c76a80049abbb4078d46ead2))

- *(linux)* Move raspberry pis over to impermanence - ([f3076e5](https://github.com/JayRovacsek/nix-config/commit/f3076e57b34dcafbb2dee21a0519214c589d0b33))

- *(linux)* Add ivysaur host for rpi5 - ([ccae3ba](https://github.com/JayRovacsek/nix-config/commit/ccae3ba15fa165d5127f2b54bff7d95bdfd43272))

- *(linux)* Implement tentacruel microvm for home-assistant - ([ab2e63b](https://github.com/JayRovacsek/nix-config/commit/ab2e63b9f87f27d4afabdcc90b2dac41e07693db))

- *(linux,iac)* Add bazarr exposure via subdomain - ([ade69c5](https://github.com/JayRovacsek/nix-config/commit/ade69c55ed5055ebd0d8e459b6053f82af5eb950))

- *(modules)* Upgrade nextcloud to v31 - ([75e9514](https://github.com/JayRovacsek/nix-config/commit/75e95148c971b73f16bd8cbb3216d65d25029d0e))

- *(modules)* Enable remote play and firewall open for gamescope & steam - ([1d2f249](https://github.com/JayRovacsek/nix-config/commit/1d2f249fa57ca145fb676fce3c234285d805da8c))

- *(modules)* Bump deluge download limit - ([a1a4b7a](https://github.com/JayRovacsek/nix-config/commit/a1a4b7a3d48964b2db7cca2ce97b5d3d1869ffd7))

- *(modules,linux)* Add new open setting to nvidia & force to false on alakazam - ([0cffd10](https://github.com/JayRovacsek/nix-config/commit/0cffd1035b2fb15e5a7724216465361b88ff6149))

- *(modules,linux)* Create bazarr module and host - ([f5a1184](https://github.com/JayRovacsek/nix-config/commit/f5a118416d9c03acae1df7c8ca85d211fff6180c))

- *(overlays)* Readd jellyfin overlay for wayland - ([0f2e817](https://github.com/JayRovacsek/nix-config/commit/0f2e81765fa7e41faa6a100b409cea35ad5472ea))

- *(overlays)* Add exif 12.7 overlay - ([63d1df6](https://github.com/JayRovacsek/nix-config/commit/63d1df67c4cd6373d0edae5bb8a696efd58596f2))

- *(packages)* Remove unused packages - ([356e9de](https://github.com/JayRovacsek/nix-config/commit/356e9de8c652779a5f5c1b42a15c350e23965cdd))
- Remove code server - ([b5740bc](https://github.com/JayRovacsek/nix-config/commit/b5740bc09e1942a207cc18a69639bb253ad632df))


### 🐛 Bug Fixes

- *(common)* Correct nidoking ip - ([189899f](https://github.com/JayRovacsek/nix-config/commit/189899fbef02361400c47a67fd1c73c89d841483))

- *(common,modules)* Resolve ha server host setting and topology issues - ([fa0facc](https://github.com/JayRovacsek/nix-config/commit/fa0facc8385ce0fe0d5366e8235d56b6d15bae37))

- *(darwin)* Resolve issues with darwin configurations - ([e5bb102](https://github.com/JayRovacsek/nix-config/commit/e5bb102282979eb4829c947ddbeb1bf33a9dd357))

- *(flake)* Allow duplicate nixpkgs on raspberry-pi flake - ([eba10f1](https://github.com/JayRovacsek/nix-config/commit/eba10f140a0c9f0611dee69349ada76b4c2a87b5))

- *(flake)* Deduplicate input sources - ([a1a4b7a](https://github.com/JayRovacsek/nix-config/commit/a1a4b7a3d48964b2db7cca2ce97b5d3d1869ffd7))

- *(flake,module)* Resolve booting issues for microvms by pinning temporarily - ([3a08859](https://github.com/JayRovacsek/nix-config/commit/3a08859c949c9a5d627a822259ae21c0558718c6))

- *(flake,modules)* Resolve nur module issues - ([4c4693b](https://github.com/JayRovacsek/nix-config/commit/4c4693ba69650342e980bf5e7f54f02d1a115d3d))

- *(flake,packages)* Resolve evaluation errors - ([ac1991a](https://github.com/JayRovacsek/nix-config/commit/ac1991acf21f215cb2277db3f056781dfbee65c8))

- *(home-manager-modules)* Migrate vscode and firefox settings to new upstream settings structures - ([224ab5b](https://github.com/JayRovacsek/nix-config/commit/224ab5b46edacb2f2f9f953ccd91feb434feb94b))

- *(home-manager-modules)* Remove restic mapping from impermanence - ([d167b8e](https://github.com/JayRovacsek/nix-config/commit/d167b8e5aacf089d18b71139abcaa1134de2889d))

- *(home-manager-modules)* Add ssh ghostty xterm variable to not bust remote sessions - ([7347385](https://github.com/JayRovacsek/nix-config/commit/7347385fa16d13ade7de4ead66165ba6010de7fc))

- *(home-manager-modules)* Remove hardcoded hostnames from ssh config match blocks - ([7347385](https://github.com/JayRovacsek/nix-config/commit/7347385fa16d13ade7de4ead66165ba6010de7fc))

- *(home-manager-modules)* Change typst lsp for tinymist - ([b0d0f8d](https://github.com/JayRovacsek/nix-config/commit/b0d0f8dd54a2852c3c76869a823b204e8ab21247))

- *(home-manager-modules)* Resolve hyprland display issue on alakazam - ([6c0acb6](https://github.com/JayRovacsek/nix-config/commit/6c0acb68cfa3cbc2e5d5efd57d5c021dad80771b))

- *(home-manager-modules)* Resolve broken ghostty module - ([f519a1c](https://github.com/JayRovacsek/nix-config/commit/f519a1ce26fe196a7e19532f9585a6381235d014))

- *(linux)* Remove deprecated recognise setting from nidoking - ([a7afbf5](https://github.com/JayRovacsek/nix-config/commit/a7afbf566cec1c2942b8f8c94b99ed6763369981))

- *(linux)* Resolve impermanence root fs issue for wartortle and ivysaur - ([79aa103](https://github.com/JayRovacsek/nix-config/commit/79aa1034a88e53eadd57be60b2eed126883735d6))

- *(linux)* Resolve any uses of hardware.pulseaudio - ([779d42b](https://github.com/JayRovacsek/nix-config/commit/779d42b83fac0e2b9beac7cdcd07663b68ee797a))

- *(linux,common)* Move ghostty to desktop rather than cli - ([2f27edb](https://github.com/JayRovacsek/nix-config/commit/2f27edb391129a641046469d2264a0d89f7e3316))

- *(linux,iac)* Resolve memories exif issues by pinning input pkg - ([52e209a](https://github.com/JayRovacsek/nix-config/commit/52e209a1a15a76063f30411b8c85fc1c52316bd2))

- *(modules)* Add language options to nextcloud and redis cache - ([33ed364](https://github.com/JayRovacsek/nix-config/commit/33ed364e4133c2e50773b1e44660a903511327e8))

- *(modules)* Resolve upload issues for nextcloud - ([725b938](https://github.com/JayRovacsek/nix-config/commit/725b93858fd3e2eeee98a88cdb04e58cb14db8fd))

- *(modules)* Resolve jellyfin settings issues - ([77d9838](https://github.com/JayRovacsek/nix-config/commit/77d983893bc3282e177864d05b5c59b24c4ee953))

- *(modules,home-manager-modules)* Update gnome to work with stylix - ([e2ae69f](https://github.com/JayRovacsek/nix-config/commit/e2ae69f0d82d6ad6b82fca3a9f57f1c89c592e39))

### ⚙️ Options

- *(modules)* Resolve jellyfin settings issues - ([77d9838](https://github.com/JayRovacsek/nix-config/commit/77d983893bc3282e177864d05b5c59b24c4ee953))

- *(modules)* Resolve jellyfin settings issues - ([77d9838](https://github.com/JayRovacsek/nix-config/commit/77d983893bc3282e177864d05b5c59b24c4ee953))

### 🚜 Refactor

- *(common)* Add home-manager to impermanence module set - ([04b280d](https://github.com/JayRovacsek/nix-config/commit/04b280d4c43210e969f29846482fc86b9d9b52dd))

- *(common)* Remove sd from rpi images by default - ([9c12b35](https://github.com/JayRovacsek/nix-config/commit/9c12b35ca12ad169333e65e850f551ac0e6c1316))

- *(home-manager-modules)* Use optionals rather than osConfig for home-manager package set - ([5fbcee4](https://github.com/JayRovacsek/nix-config/commit/5fbcee4cfd7e82ddb24b27269a423b639bb0da21))

- *(home-manager-modules)* Remove r2modman from game set - ([4740228](https://github.com/JayRovacsek/nix-config/commit/4740228e373f1fd2a74d278c20c8d155b6a3380f))

- *(home-manager-modules)* Remove ghostty as it is supported upstream - ([2f27edb](https://github.com/JayRovacsek/nix-config/commit/2f27edb391129a641046469d2264a0d89f7e3316))

- *(linux)* Stop porygon from running - ([383f96d](https://github.com/JayRovacsek/nix-config/commit/383f96d7053ea3e6b541f0b207379617bea455bd))

- *(linux,flake)* Remove armv6 and armv7 binfmt registrations - ([be6a4d2](https://github.com/JayRovacsek/nix-config/commit/be6a4d2fbaca565c49de976d2c7bee2ebe325da6))

- *(modules)* Remove overlays for intro-skipper from jellyfin - ([a90b589](https://github.com/JayRovacsek/nix-config/commit/a90b58997248f3b008968e49fe8cca781cbe8697))

- *(modules)* Resolve use of hardware.pulseaudio and reorder rpi settings - ([aaae487](https://github.com/JayRovacsek/nix-config/commit/aaae487ad42ef66b826c0771f71e905bc989ec6b))

- *(modules)* Remove samba module - ([23903c8](https://github.com/JayRovacsek/nix-config/commit/23903c8436a4566e015d67bd18e33765d937718c))

- *(overlays)* Remove jellyfin-wayland overlay - ([0123de7](https://github.com/JayRovacsek/nix-config/commit/0123de72eb72098ad2ee9fa2499eae008495274e))

- *(tooling)* Move changelog output to github folder - ([b754933](https://github.com/JayRovacsek/nix-config/commit/b754933d32f5ac231d11202219f9c334558e8bc0))

### 📚 Documentation
- Regenerate topology documentation - ([b956278](https://github.com/JayRovacsek/nix-config/commit/b95627847c27c7451c91c641aa12e2decce28aca))

## [0.0.9](https://github.com/JayRovacsek/nix-config/compare/v0.0.8..v0.0.9) - 2024-12-22

### ⛰️  Features

- *(common)* Realign github tofu with config - ([ece132c](https://github.com/JayRovacsek/nix-config/commit/ece132c1e29217b66bf308414c362674f6161d72))

- *(darwin)* Enable remote builds on victreebel - ([59368c8](https://github.com/JayRovacsek/nix-config/commit/59368c8b491278f1d8bbd99943a2b8f2ad551ef9))

- *(docs)* Refactor topology & readme to correct current deployment - ([02bd873](https://github.com/JayRovacsek/nix-config/commit/02bd873c5e5bd2a2cf36ed92c0fad719ded0dbdd))

- *(flake)* Bump lix to 2.91.1 - ([c6f6f4b](https://github.com/JayRovacsek/nix-config/commit/c6f6f4b4a27a8cf4be077e436d643936b92fdf7c))

- *(flake)* Pin nuschtos-modules to avoid eval error - ([98221a9](https://github.com/JayRovacsek/nix-config/commit/98221a98dd7bb4a3e6354b386dcfe33bc89b10c2))

- *(flake)* Ping flaresolverr input to avoid using a build from source candidate - ([98221a9](https://github.com/JayRovacsek/nix-config/commit/98221a98dd7bb4a3e6354b386dcfe33bc89b10c2))

- *(flake)* Expose secret public key configurations via outputs - ([810b6b1](https://github.com/JayRovacsek/nix-config/commit/810b6b1ba3f5a46040d3a555c178f8f281fd0572))

- *(flake)* Update hydra-api-input to default branch - ([38a25c4](https://github.com/JayRovacsek/nix-config/commit/38a25c4f72d967a07c70df880486890be3740069))

- *(flake)* Unpin lix input - ([edecadb](https://github.com/JayRovacsek/nix-config/commit/edecadbcf26402c3f406ee002a738c91627011f2))

- *(flake,iac,hydra,packages)* Minor issue resolutions to a range of properties - ([73225fd](https://github.com/JayRovacsek/nix-config/commit/73225fd8264e1042e4687e1616d1797db5cabdaa))

- *(home-manager-modules)* Implement atuin - ([f7bd0fb](https://github.com/JayRovacsek/nix-config/commit/f7bd0fb1ab1de3dfa58581c086ddcb7e17bd89a9))

- *(home-manager-modules)* Disable zsh completions (conflict with modules) - ([0556b8a](https://github.com/JayRovacsek/nix-config/commit/0556b8a4010afa743b0b07a9a37fd419721807af))

- *(home-manager-modules)* Add thunderbird to impermanence - ([a866613](https://github.com/JayRovacsek/nix-config/commit/a866613829fbe4034310e0906f88b513d52a3a2f))

- *(home-manager-modules)* Add vscodium state dir - ([a8d4b42](https://github.com/JayRovacsek/nix-config/commit/a8d4b42980bd4139261e9ddaf2cfa5cfd483ea5a))

- *(home-manager-modules)* Implement r2modman module - ([de71633](https://github.com/JayRovacsek/nix-config/commit/de71633e438206ebebf4ee66ab63c77198df1a56))

- *(home-manager-modules)* Align swaync with system colours - ([3e5e300](https://github.com/JayRovacsek/nix-config/commit/3e5e3001cdf07afc29d83ac80ca2e9dffaa266f2))

- *(home-manager-modules)* Add hyprpaper module - ([dc1630b](https://github.com/JayRovacsek/nix-config/commit/dc1630b3dd0e0a94e70076b4c89968755ea4fa45))

- *(home-manager-modules)* Add hypridle - ([625aca5](https://github.com/JayRovacsek/nix-config/commit/625aca5cfde4877591dae0d484b28900d9e30bed))

- *(home-manager-modules)* Add swaync - ([fcc1fb8](https://github.com/JayRovacsek/nix-config/commit/fcc1fb8f81c31c06bea2f6b905dca5b987212fe8))

- *(home-manager-modules,common)* Add ai modules - ([324ae70](https://github.com/JayRovacsek/nix-config/commit/324ae70039dea42a75ae1e255bc662bc1e51e54d))

- *(home-manager-modules,options)* Extend ollama to linux - ([399650f](https://github.com/JayRovacsek/nix-config/commit/399650fb19cde5efcda659c47f99e2f8b28b8143))

- *(iac)* Add ncsg october 2024 repo - ([ef13ea9](https://github.com/JayRovacsek/nix-config/commit/ef13ea93d5166d4ac8f8081fbe5f5971a7de508a))

- *(iac)* Un archive nix-options, eval on each change is ridiculous - ([a8de228](https://github.com/JayRovacsek/nix-config/commit/a8de2283d1b1925a7f8aab64d29c5dce4279f299))

- *(iac)* Move aws state stack, add false positives to tofu app - ([ca670b5](https://github.com/JayRovacsek/nix-config/commit/ca670b5f541b908ba300a0fcb8f8efbc722a76b5))

- *(iac)* Add hydra-badge-api repository to github - ([9a121af](https://github.com/JayRovacsek/nix-config/commit/9a121af011f1398fef7d76947f282cf1ce911814))

- *(iac)* Archive nix-options - ([ebd54e6](https://github.com/JayRovacsek/nix-config/commit/ebd54e6caf5a283a01e5652e68324b06c9b45ec8))

- *(iac)* Add nix-inputs to assess viability of concept - ([6d9e809](https://github.com/JayRovacsek/nix-config/commit/6d9e809bc041f2de8a8d1f197bb78f9622962c30))

- *(images,modules)* Add basic pi5 sd image and module - ([1425bb1](https://github.com/JayRovacsek/nix-config/commit/1425bb13ab4339a767c5efe67e479227be4bad66))

- *(linux)* Move wigglytuff home to impermanence - ([4e2cd27](https://github.com/JayRovacsek/nix-config/commit/4e2cd27a763cb9fab9a4b61e13d07364edd94b98))

- *(linux)* Bump rootfs size on alakazam - ([a8d4b42](https://github.com/JayRovacsek/nix-config/commit/a8d4b42980bd4139261e9ddaf2cfa5cfd483ea5a))

- *(linux)* Move alakazam to impermanence - ([810b6b1](https://github.com/JayRovacsek/nix-config/commit/810b6b1ba3f5a46040d3a555c178f8f281fd0572))

- *(linux)* Migrate alakazam to disko - ([810b6b1](https://github.com/JayRovacsek/nix-config/commit/810b6b1ba3f5a46040d3a555c178f8f281fd0572))

- *(linux)* Revive porygon, add services to it - ([3fc5dad](https://github.com/JayRovacsek/nix-config/commit/3fc5dad8d4f28f9460751697840b7b855816e86e))

- *(linux)* Give all microvms a common ancestor - ([31ca60f](https://github.com/JayRovacsek/nix-config/commit/31ca60f5e45d819e9536a2d5fc1e19a5550460b6))

- *(linux)* Add badge endpoint to nginx for nidorina - ([a07799d](https://github.com/JayRovacsek/nix-config/commit/a07799da82031d8b452dcffd2374a87a7fd75c75))

- *(linux)* Remove swap device from gastly - ([3c8fb5f](https://github.com/JayRovacsek/nix-config/commit/3c8fb5fd43be24e0a9db585f8bc455bd9d886b79))

- *(linux)* Remove swap from zram devices with strong cpus - ([2be11a3](https://github.com/JayRovacsek/nix-config/commit/2be11a3309fb448d2263134e767c8c56ee7b3e87))

- *(linux)* Remove ollama from alakazam for now - ([6614bb6](https://github.com/JayRovacsek/nix-config/commit/6614bb62243fb041a4385c586d9ef0e18244535c))

- *(linux)* Add zram to gastly - ([c147384](https://github.com/JayRovacsek/nix-config/commit/c14738495899385df0d4eb6e0eb60d7876c94c8f))

- *(linux)* Retire cloyster to lavender tower - ([9a899d5](https://github.com/JayRovacsek/nix-config/commit/9a899d53c4005afce31194b5cd2cd49ff117223d))

- *(linux)* Start implementation of rpi0w - ([fe785b8](https://github.com/JayRovacsek/nix-config/commit/fe785b8f8b205a9e61c671caee65f1eee52d2811))

- *(linux)* Disable dragonite auto update - ([157b366](https://github.com/JayRovacsek/nix-config/commit/157b366a184d508b517a829d74794c4cea670a24))

- *(linux)* Move gastly to ironbar - ([f995b82](https://github.com/JayRovacsek/nix-config/commit/f995b82b3ab7ba80e53dcd649b21eabbaa02402b))

- *(linux,images,common)* Rename rpi0w, exclude from hydra - ([1d33cfa](https://github.com/JayRovacsek/nix-config/commit/1d33cfada64df54a76a04f61a9e0017624518eac))

- *(linux,modules)* Move grafana behind authelia - ([7744144](https://github.com/JayRovacsek/nix-config/commit/7744144a88d639fcce126ecc2faa9c6e6b9f9284))

- *(linux,modules)* Add ollama to alakazam - ([ba81918](https://github.com/JayRovacsek/nix-config/commit/ba81918c3d1e675b5c356e24f9880edb51ee95dd))

- *(linux,modules,flake)* Migrate from imperative to declarative microvms - ([a280577](https://github.com/JayRovacsek/nix-config/commit/a28057709d2904b7a0bae8029d72ca8937faa6b1))

- *(modules)* Move microvm guests to hardened linux - ([9cb1258](https://github.com/JayRovacsek/nix-config/commit/9cb1258924a89c13592729a4187ce4f882909e5b))

- *(modules)* Change lix to from nixpkgs - ([26c5ed0](https://github.com/JayRovacsek/nix-config/commit/26c5ed06a26e698a5af0f71054165f417340afa6))

- *(modules)* Remove persistent home directory - ([f44d805](https://github.com/JayRovacsek/nix-config/commit/f44d8059243292572de6a05f41849cae0231adb1))

- *(modules)* Utilise production package for nvidia - ([a84bf24](https://github.com/JayRovacsek/nix-config/commit/a84bf249f6266be2d84343e62f253d9148df7653))

- *(modules)* Add basic grafana dashboards - ([d93cf00](https://github.com/JayRovacsek/nix-config/commit/d93cf00f98209bc140d4b5d8ab8a75cbf28f9107))

- *(modules)* Add secrets for grafana - ([7744144](https://github.com/JayRovacsek/nix-config/commit/7744144a88d639fcce126ecc2faa9c6e6b9f9284))

- *(modules)* Remove binblocks - ([fa3a6db](https://github.com/JayRovacsek/nix-config/commit/fa3a6db9c42bc7ac16a0f5ae39c16284b473b7f4))

- *(modules)* Implement ledger module - ([98b4385](https://github.com/JayRovacsek/nix-config/commit/98b4385fedde6fe00852f2f395d0ef25174a17a9))

- *(modules)* Implement harmonia - ([262a2b9](https://github.com/JayRovacsek/nix-config/commit/262a2b9f0c4516a6ac2c93e2089cc2e51b32eac5))

- *(modules)* Add hydra grafana job - ([7d889b1](https://github.com/JayRovacsek/nix-config/commit/7d889b13063f9d1725d648ccb91e01c1edab17fd))

- *(modules)* Utilise upstream flaresolverr options - ([c8b0ceb](https://github.com/JayRovacsek/nix-config/commit/c8b0ceb5aff53c021136a603ab2560763d127286))

- *(modules)* Provide escape hatch for extra args to be utilised - ([a280577](https://github.com/JayRovacsek/nix-config/commit/a28057709d2904b7a0bae8029d72ca8937faa6b1))

- *(modules)* Add optional import for microvm-guest module to avoid issue in declarative settings - ([a280577](https://github.com/JayRovacsek/nix-config/commit/a28057709d2904b7a0bae8029d72ca8937faa6b1))

- *(modules)* Regenerate tailscale keys with per-host configs - ([eeaa19c](https://github.com/JayRovacsek/nix-config/commit/eeaa19c41a098d1829edb01f584203b535f52e77))

- *(modules,flake)* Re-introduce lix with nix-store regression sorted - ([c904d7c](https://github.com/JayRovacsek/nix-config/commit/c904d7c19e9e96b26b208a9f0d763490d1342de9))

- *(modules,home-manager-modules)* Implement minimal bluetooth module - ([c7c7e79](https://github.com/JayRovacsek/nix-config/commit/c7c7e7906faf3c5abde3b555c75e996d743c0e4d))

- *(modules,home-manager-modules)* Remove some vsc plugins - ([6d7793a](https://github.com/JayRovacsek/nix-config/commit/6d7793a353727d800331c50177e62a704595ad0d))

- *(modules,home-manager-modules)* Re-add nix-options - ([46f85b4](https://github.com/JayRovacsek/nix-config/commit/46f85b4fe8ff776ef5ee3bd8a2ded8383920247b))

- *(modules,hydra)* Introduce hydra badge api into config - ([c615eb9](https://github.com/JayRovacsek/nix-config/commit/c615eb9a97d7aec6a34b9fafac5838a8ca93eeff))

- *(modules,lib)* Add KTLS & resolver to nginx - ([5f4e578](https://github.com/JayRovacsek/nix-config/commit/5f4e578b33f3373e3f69ba509fc692c5c2b75324))

- *(modules,linux)* Implement zramSwap module - ([a6c4098](https://github.com/JayRovacsek/nix-config/commit/a6c409881250bb24de8ef56ab75d8c62cb20a3c7))

- *(modules,linux)* Create openvpn-server module - ([119e24d](https://github.com/JayRovacsek/nix-config/commit/119e24de7b00ae3a2654dd5e092c448a9db45e0c))

- *(modules,options)* Add hydra auto upgrade - ([2db3dd9](https://github.com/JayRovacsek/nix-config/commit/2db3dd919f380970dbb8fba18746ba5b97d35a75))

- *(options,lib)* Self reference for available options - ([c33f661](https://github.com/JayRovacsek/nix-config/commit/c33f6613e5463f25383f5e6708f4fa7f17b25d29))

- *(overlays)* Remove sonarr overlay - ([9cfa50d](https://github.com/JayRovacsek/nix-config/commit/9cfa50d0adb4f03cab8b75ad59d1b66caafbaa29))

- *(packages)* Implement bedrock connect & geyser minecraft - ([3fc5dad](https://github.com/JayRovacsek/nix-config/commit/3fc5dad8d4f28f9460751697840b7b855816e86e))

- *(packages)* Implement minecraft bedrock server package - ([f300107](https://github.com/JayRovacsek/nix-config/commit/f300107418f50d97d0da2b0847156992cfa632df))

- *(packages)* Expose disko packages - ([78f0a74](https://github.com/JayRovacsek/nix-config/commit/78f0a74a0e454d58c543218d7e00b742a84ffdc3))

- *(packages)* Package mdtable - ([c1bbf68](https://github.com/JayRovacsek/nix-config/commit/c1bbf68c2ad154b8dadf9733717a68d5057be7a6))

- *(packages)* Package tablemark - ([858f817](https://github.com/JayRovacsek/nix-config/commit/858f817e84725a0f643e0ca678ac4ac4e86bf2d3))

- *(packages)* Implement aerospace package - ([9f53268](https://github.com/JayRovacsek/nix-config/commit/9f5326827c0c07e36b3d15c3c1cff4cd98cf089a))

- *(packages)* Update github tenancy - ([5be83d5](https://github.com/JayRovacsek/nix-config/commit/5be83d5a089edfbe17f5460390484061119dfdf9))

- *(tooling,iac)* Augment existing documentation step for tofu stacks - ([ff3f21a](https://github.com/JayRovacsek/nix-config/commit/ff3f21add9133e09d7d033622093c5f7630e9362))
- Remove rpi0, 1 and 2 configs, add 4 as an extension case - ([5c6f8e5](https://github.com/JayRovacsek/nix-config/commit/5c6f8e57c083230d71e56cb1229873746736c6c7))

- Introduce a home-manager agenix module - ([810b6b1](https://github.com/JayRovacsek/nix-config/commit/810b6b1ba3f5a46040d3a555c178f8f281fd0572))

- Add remote builds to dragonite - ([4f41649](https://github.com/JayRovacsek/nix-config/commit/4f41649c23f326241300290618951c61e5fd3b15))

- Add shield.io badges - ([83e7ebd](https://github.com/JayRovacsek/nix-config/commit/83e7ebd0db8978860cfd8d52cf4902cfaeda2740))

- Implement aerospace options and home manager module - ([56481dc](https://github.com/JayRovacsek/nix-config/commit/56481dcec78125be5c6c34b99729b66026546477))


### 🐛 Bug Fixes

- *(common)* Add aarch and x86 images for oracle - ([157b366](https://github.com/JayRovacsek/nix-config/commit/157b366a184d508b517a829d74794c4cea670a24))

- *(darwin)* Remove some mas apps from darwin configs - ([d7474a0](https://github.com/JayRovacsek/nix-config/commit/d7474a088f086dfeb7c4d688fbba3bd81d6bf22d))

- *(darwin)* Resolve issues with rebuilding on darwin - ([f6715da](https://github.com/JayRovacsek/nix-config/commit/f6715da1899aab4b60fc278c04ebd06e3be0b75b))

- *(darwin)* Update nix-darwin to rebuild victreebel - ([abc7f8b](https://github.com/JayRovacsek/nix-config/commit/abc7f8b04083bdb7c5efd9037ce0ff3519d88371))

- *(darwin)* Resolve migration issues to age hm onm darwin - ([039e41e](https://github.com/JayRovacsek/nix-config/commit/039e41e8b3cc1303fa3a6334b3561adec4a2319c))

- *(darwin)* Resolve auto-optimise issues on darwin - ([288d237](https://github.com/JayRovacsek/nix-config/commit/288d237e7b36209f0b780d43dd1d57835e9ddfd4))

- *(darwin)* Add ssh module to victreebel - ([f8ea52a](https://github.com/JayRovacsek/nix-config/commit/f8ea52a9c7886edc4f2ac8b6807eadb604dcd91d))

- *(darwin)* Start resolving issues with ninetales - ([98b4385](https://github.com/JayRovacsek/nix-config/commit/98b4385fedde6fe00852f2f395d0ef25174a17a9))

- *(flake)* Add crane input to avoid issues on ironbar - ([c6f6f4b](https://github.com/JayRovacsek/nix-config/commit/c6f6f4b4a27a8cf4be077e436d643936b92fdf7c))

- *(flake)* Unpin flaresolverr and nuschtos - ([85d1763](https://github.com/JayRovacsek/nix-config/commit/85d1763feba08beb43664bd85d71c4c7d8be06c0))

- *(flake)* Pin lix input correctly - ([445dadc](https://github.com/JayRovacsek/nix-config/commit/445dadc549fc19352fe9b4cf6533b9b2654583e0))

- *(home-manager-modules)* Resolve screen ordering issue - ([4d5052f](https://github.com/JayRovacsek/nix-config/commit/4d5052f5dc21b455bcfbcb8a55eb5ba3a4bc82c7))

- *(home-manager-modules)* Resolve impermanence for keepassxc - ([c01b1be](https://github.com/JayRovacsek/nix-config/commit/c01b1beb2229cce3a845c364205308b7356fd7f1))

- *(home-manager-modules)* Add previous profile to thunderbird config - ([58469c1](https://github.com/JayRovacsek/nix-config/commit/58469c1197b41062165ef07b0f03fd1500397e37))

- *(home-manager-modules)* Add thunderbird to impermanence - ([264b5ab](https://github.com/JayRovacsek/nix-config/commit/264b5ab57717a5a5e444e815dcff051336e15223))

- *(home-manager-modules)* Rewrite elements of thunderbird - ([5c48fd6](https://github.com/JayRovacsek/nix-config/commit/5c48fd6c253576c4d86bec35a5262405b48d9fff))

- *(home-manager-modules)* Remove deprecated hyprland options - ([4b0933a](https://github.com/JayRovacsek/nix-config/commit/4b0933a0027e8e1379726020be836a87cdb80e24))

- *(home-manager-modules)* Resolve steam issues and add ollama persistence - ([ffa0941](https://github.com/JayRovacsek/nix-config/commit/ffa094151974ac2f237defa69dd562b3fb45f565))

- *(home-manager-modules)* Add xdg applications for firefox - ([a8d4b42](https://github.com/JayRovacsek/nix-config/commit/a8d4b42980bd4139261e9ddaf2cfa5cfd483ea5a))

- *(home-manager-modules)* Only reference signing file if suitable - ([a14fd1b](https://github.com/JayRovacsek/nix-config/commit/a14fd1b4aff14e2f0659eebe8d5642a6e9fc73ab))

- *(home-manager-modules)* Resolve screen ordering issue - ([810b6b1](https://github.com/JayRovacsek/nix-config/commit/810b6b1ba3f5a46040d3a555c178f8f281fd0572))

- *(home-manager-modules)* Add       web-devicons plugin - ([8ddc456](https://github.com/JayRovacsek/nix-config/commit/8ddc456e9b767435b63d86e14eff2ebcc473e716))

- *(home-manager-modules)* Resolve hyprland monitors issue - ([0604658](https://github.com/JayRovacsek/nix-config/commit/060465861dfcc06d8d261853baec1e946e2afa60))

- *(home-manager-modules)* Resolve screen issues - ([5b906b3](https://github.com/JayRovacsek/nix-config/commit/5b906b3a4063feb585d4548ec8249eb95f483409))

- *(home-manager-modules)* Resolve firefox and keepass issues - ([94aaa04](https://github.com/JayRovacsek/nix-config/commit/94aaa043ce5360ae0a7731833a2633f70e805e54))

- *(home-manager-modules)* Add bandaid fix for firefox on - ([e1d74d5](https://github.com/JayRovacsek/nix-config/commit/e1d74d5f01da5c6bfce628b011211c61c48d5c22))

- *(home-manager-modules)* Resolve sway css -> nix migration issues - ([84e9f73](https://github.com/JayRovacsek/nix-config/commit/84e9f73a552d12d1cef31da1d3f57e3c980e1f52))

- *(home-manager-modules)* Change keepass to not minimise on start - ([15bb2e2](https://github.com/JayRovacsek/nix-config/commit/15bb2e227e33989ce756446e8db07bd5982c4783))

- *(hydra)* Remove rpi4 and 5 from hydra jobs temporarily - ([c9cde4e](https://github.com/JayRovacsek/nix-config/commit/c9cde4e26351f4e734b668522de9cfd3806a9620))

- *(hydra)* Add explicit protocol - ([98c84bc](https://github.com/JayRovacsek/nix-config/commit/98c84bc7c08e443e0ca3c1545d2d5bbfb63fc826))

- *(hydra)* Resolve logic for broken packages - ([156769d](https://github.com/JayRovacsek/nix-config/commit/156769dbb82f0dd40e4f51f75943a7725ddf75f1))

- *(hydra)* Avoid building amazon image for now - ([604d779](https://github.com/JayRovacsek/nix-config/commit/604d7797bee5765327bc0b3fbe4ff160c17417c6))

- *(hydra)* Remove problematic packages from hydra - ([5b906b3](https://github.com/JayRovacsek/nix-config/commit/5b906b3a4063feb585d4548ec8249eb95f483409))

- *(hydra)* Resolve inclusion of broken config - ([3431e9c](https://github.com/JayRovacsek/nix-config/commit/3431e9ce335feb8c7fc1c72edd1d24b8eb99d92f))

- *(hydra,iac)* Resolve evaluation issues with rpi4 base image - ([e7c0753](https://github.com/JayRovacsek/nix-config/commit/e7c0753a44ab59b5070c561a6871f6fd05c9d58e))

- *(hydra,packages)* Remove raw configurations from packages - ([7827dfb](https://github.com/JayRovacsek/nix-config/commit/7827dfbafe936e3ef9d236d637197915f415599f))

- *(iac)* Resolve remote builder issues - ([a589677](https://github.com/JayRovacsek/nix-config/commit/a5896773dce56a7cdc9ae64571bc2a9bd84c75b7))

- *(iac)* Resolve typo - ([b5b3e5b](https://github.com/JayRovacsek/nix-config/commit/b5b3e5b05e10e2ff3e1deedbbed5ca3ce853efc6))

- *(iac)* Correct provider name in oracle tofu stack - ([b2ba376](https://github.com/JayRovacsek/nix-config/commit/b2ba376cc3b3c54c90138a92f307f21c5ec428d0))

- *(iac,images)* Re-add hydra jobs - ([9106967](https://github.com/JayRovacsek/nix-config/commit/910696782ed8a3eaa375c1595a816b10d8f31285))

- *(lib)* Fix failure case for users where age might not be present - ([119e24d](https://github.com/JayRovacsek/nix-config/commit/119e24de7b00ae3a2654dd5e092c448a9db45e0c))

- *(linux)* Bump slowpoke's ram to 1gb - ([4a39754](https://github.com/JayRovacsek/nix-config/commit/4a39754e985c7f709ccd87dd68661c921f3c99d3))

- *(linux)* Bump memory of meowth - ([98221a9](https://github.com/JayRovacsek/nix-config/commit/98221a98dd7bb4a3e6354b386dcfe33bc89b10c2))

- *(linux)* Enable root login on ditto to enable userless system definitions - ([98dd08a](https://github.com/JayRovacsek/nix-config/commit/98dd08aeca9d1471e7dd908c2d0dc0f8f2e9cdad))

- *(linux)* Remove agenix from jigglypuff - ([792dcaf](https://github.com/JayRovacsek/nix-config/commit/792dcaf177edaad76da69f297580a9f493e9edd5))

- *(linux)* Resolve changed media definition - ([1bc7e03](https://github.com/JayRovacsek/nix-config/commit/1bc7e039b0ac5b99f0bb23e475920c929fc183fd))

- *(linux)* Resolve tailscale module issues - ([655a96a](https://github.com/JayRovacsek/nix-config/commit/655a96aca945874ff1588820486af27734912236))

- *(linux)* Resolve nginx entry error - ([a287446](https://github.com/JayRovacsek/nix-config/commit/a287446ff36cc24eb685467d6a584cfbbd220284))

- *(linux)* Remove prism and opengl option from alakazam - ([3d6107a](https://github.com/JayRovacsek/nix-config/commit/3d6107a99c949d74b79e259cda456ff530926c51))

- *(linux)* Bump binarycache timeout on nidorina - ([9ef258c](https://github.com/JayRovacsek/nix-config/commit/9ef258cfbcf3fe66b57b07237a5ef801e43dac8b))

- *(linux,home-manager-modules)* Further eval issue resolutions - ([9c2011d](https://github.com/JayRovacsek/nix-config/commit/9c2011d674abd903d5e4daa13da48cad02daad83))

- *(linux,hydra)* Temporarily force dragonite to only build locally - ([b8695ed](https://github.com/JayRovacsek/nix-config/commit/b8695edeb98508984263d3f1ef8e02fa8de9894d))

- *(linux,hydra)* Resolve remote builder key references - ([62b5253](https://github.com/JayRovacsek/nix-config/commit/62b5253ac8cdee0b6bf4ce884b1eb00cc9ecc554))

- *(linux,iac)* Add host stub for rpi5 image, remove sd image from jobs - ([9f63dcd](https://github.com/JayRovacsek/nix-config/commit/9f63dcddb11b6edee433b5dce08deed69f06b1fe))

- *(linux,modules)* Resolve grafana service issues - ([d93cf00](https://github.com/JayRovacsek/nix-config/commit/d93cf00f98209bc140d4b5d8ab8a75cbf28f9107))

- *(linux,modules)* Add uris to hydra allowed, bump mr-mime RAM - ([d0a9e5a](https://github.com/JayRovacsek/nix-config/commit/d0a9e5af5428420f37c98c92926483aaf5ae7c53))

- *(modules)* Move rpi5 over to nix-community flake - ([9b956b4](https://github.com/JayRovacsek/nix-config/commit/9b956b413329fcbc35f5b7f32cc7a8cb62db9364))

- *(modules)* Add permitted eol packages to packagesets - ([2dfb902](https://github.com/JayRovacsek/nix-config/commit/2dfb90204f0ee85daabca2555605d9acd30e66df))

- *(modules)* Utilise nur flaresolverr package that works - ([ebb0415](https://github.com/JayRovacsek/nix-config/commit/ebb04159e65629230ed9d87f62b804d1d6f38eea))

- *(modules)* Remove deprecated raspberry pi option - ([f3eac60](https://github.com/JayRovacsek/nix-config/commit/f3eac607ee2f6bc4175682f0d6d6f657a935804b))

- *(modules)* Resolve dynamic dns issues - ([6a3f5a4](https://github.com/JayRovacsek/nix-config/commit/6a3f5a49e9b55253b636ceade64d94748dcd8585))

- *(modules)* Allow hydra access to nuschtos - ([fac7645](https://github.com/JayRovacsek/nix-config/commit/fac7645145fd775ca56ad89e20764c7ae42b51f6))

- *(modules)* Add websocket proxy to jellyfin - ([8f3d11b](https://github.com/JayRovacsek/nix-config/commit/8f3d11bd21ca59ecdee4eb7043de45c4aeb0623c))

- *(modules)* Utilise mongodb-ce for unifi - ([89b1510](https://github.com/JayRovacsek/nix-config/commit/89b15100d72a406864e54f24390b9424550bec72))

- *(modules)* Move mongo package to a supported version - ([3efb242](https://github.com/JayRovacsek/nix-config/commit/3efb24219a282fa39512e765ca9aa91120e2403e))

- *(modules)* Add mongodb option to unifi - ([af57d26](https://github.com/JayRovacsek/nix-config/commit/af57d26ba52710df4ec12a1d27798f57fab8aa50))

- *(modules)* Add nameserver to tailscale config - ([4114056](https://github.com/JayRovacsek/nix-config/commit/4114056d782a8b43b80936d47fe8b12d48e46f0e))

- *(modules)* Resolve issues with linking across multiple block devices - ([961cc44](https://github.com/JayRovacsek/nix-config/commit/961cc4411cbc4e2037b95c0d31da39de9b69a642))

- *(modules)* Remove ip based machine configs from remote builds - ([c517ccd](https://github.com/JayRovacsek/nix-config/commit/c517ccd7afb156e593c2e4dd58a8f1dc2012e5aa))

- *(modules)* Resolve issue with linux-builder on darwin - ([d72db57](https://github.com/JayRovacsek/nix-config/commit/d72db575ce240d8f4230b90e51bdf3bb638d5364))

- *(modules)* Add optional agenix mount in impermanence - ([4802e9e](https://github.com/JayRovacsek/nix-config/commit/4802e9e512399ef7c8b9814f80473557110b5f97))

- *(modules)* Swap use of harmonia options to resolve deprecated option - ([22bf49e](https://github.com/JayRovacsek/nix-config/commit/22bf49ed1f6efd5d2c12cb3ba010ee4f006f8432))

- *(modules)* Disable nix gc on binary cache modules - ([724021f](https://github.com/JayRovacsek/nix-config/commit/724021ff80ca129fcc6eb963ab143192c67d2fd9))

- *(modules)* Move tailscale identities to hostname based - ([67a8be1](https://github.com/JayRovacsek/nix-config/commit/67a8be15e6b6c4d012c5f239225bca7c53b8ab73))

- *(modules)* Remove regression on remote builders - ([5f4e578](https://github.com/JayRovacsek/nix-config/commit/5f4e578b33f3373e3f69ba509fc692c5c2b75324))

- *(modules)* Resolve a range of changed options based on trace feedback - ([32cf11b](https://github.com/JayRovacsek/nix-config/commit/32cf11b486eae1bdc95e7e6c5a2c8e677a8a349f))

- *(modules,home-manager-modules)* Add explicit formatter path - ([127d401](https://github.com/JayRovacsek/nix-config/commit/127d401ec6f47f236999df32fa86d2ba010a7453))

- *(modules,home-manager-modules)* Resolve hash of options repo - ([bd32665](https://github.com/JayRovacsek/nix-config/commit/bd326650c2098cf1e8549f55f00fac45112a434a))

- *(modules,iac,hydra)* Resolve remote builds on dragonite - ([5c4ef9b](https://github.com/JayRovacsek/nix-config/commit/5c4ef9b872dcce9de190c70d394246643905d8dd))

- *(overlays)* Reintroduce jellyfin overlay - ([c9f5fb8](https://github.com/JayRovacsek/nix-config/commit/c9f5fb87dcf741a11e3afbc13c7dc758fb97fcfe))

- *(packages)* Resolve lancache package issues - ([45b35bc](https://github.com/JayRovacsek/nix-config/commit/45b35bc91420c49c04ed1b8b2499af7d92d2527d))

- *(packages)* Remove more tests that use network calls from cloudquery - ([ae52efe](https://github.com/JayRovacsek/nix-config/commit/ae52efe81909a697387653073c62bd5ecaaca06e))

- *(packages)* Remove tests that use network calls from cloudquery - ([4ce3d71](https://github.com/JayRovacsek/nix-config/commit/4ce3d712dee7ae816419831a3f6211b488c78c4a))

- *(packages)* Add minor version for velociraptor and resolve hashes - ([24c2687](https://github.com/JayRovacsek/nix-config/commit/24c26879694c418e8b7dbf0c4a96399e402ced2d))

- *(packages)* Resolve build issues for cloudquery - ([e182bd9](https://github.com/JayRovacsek/nix-config/commit/e182bd9bc4ac7e10ae463e5b5b2a568486a3577a))

- *(packages)* Remove broken packages - ([99dcb0c](https://github.com/JayRovacsek/nix-config/commit/99dcb0cbe459bd02f869e3e2440f598eb58a652b))

- *(packages)* Mark flask security as broken - ([604d779](https://github.com/JayRovacsek/nix-config/commit/604d7797bee5765327bc0b3fbe4ff160c17417c6))

- *(packages)* Mark purpleops as broken - ([d9a7eaa](https://github.com/JayRovacsek/nix-config/commit/d9a7eaab4554e3f0a955255aebcefe3c2b2ef269))

- *(packages)* Resolve issues with moving packages - ([19c3cbf](https://github.com/JayRovacsek/nix-config/commit/19c3cbfbb1be6b570fd4c6ffcc7c72850514eced))

- *(packages)* Fix linode AMI package & openvpn server - ([119e24d](https://github.com/JayRovacsek/nix-config/commit/119e24de7b00ae3a2654dd5e092c448a9db45e0c))

- *(packages)* Resolve broken packages - ([74fbe6f](https://github.com/JayRovacsek/nix-config/commit/74fbe6fcbe1046512778970f6b47f4bbb8709a7f))

- *(packages,hydra)* Remove bedrock server package, add uris to hydra - ([2d341d0](https://github.com/JayRovacsek/nix-config/commit/2d341d08008a60b6c38159195887058a9c680f18))

- *(static)* Update build configs - ([3ab0dda](https://github.com/JayRovacsek/nix-config/commit/3ab0ddaa8eb135235b02bf9988379926476bead2))

- *(tooling)* Add scopes to conform configuration - ([99a07f5](https://github.com/JayRovacsek/nix-config/commit/99a07f59513cfd6824a8d21875d4c8f95356f88d))
- Bump hydra-api version - ([d8733fb](https://github.com/JayRovacsek/nix-config/commit/d8733fb5a56b69f0d40b255dd430307569225a23))

- Use /tmp for clamav logs - ([cfa9793](https://github.com/JayRovacsek/nix-config/commit/cfa9793d72dcd415999d35dca8fbc349e3980114))

- Resolve headscale build issues - ([b3f93b6](https://github.com/JayRovacsek/nix-config/commit/b3f93b6da403b461f9220ad0e91e4ae69118e1f4))

- Use pname before name for assessment of impermanence - ([f44d805](https://github.com/JayRovacsek/nix-config/commit/f44d8059243292572de6a05f41849cae0231adb1))

- Re-add zsh, disabling auto-completion however - ([0aa27f6](https://github.com/JayRovacsek/nix-config/commit/0aa27f61724ff71839b37954b862eb16c3ea224d))

- Add zsh as user shell - ([dd6f4fd](https://github.com/JayRovacsek/nix-config/commit/dd6f4fdd605474c2bf221109f3256903c90fba68))

- Remove system level zsh - ([b3a0f0b](https://github.com/JayRovacsek/nix-config/commit/b3a0f0b68b422d266f45ea76bd98f355d0d21b68))

- Resolve eval issues - ([54773ee](https://github.com/JayRovacsek/nix-config/commit/54773eeeed0ba9e5bd530a78916e3c327479bb7d))

- Migrate wireless configs over to new options - ([a1e24e5](https://github.com/JayRovacsek/nix-config/commit/a1e24e5bb1c7f3c625475ced21b6b0c80d356247))

- Resolve build-machines generation - ([7920a3c](https://github.com/JayRovacsek/nix-config/commit/7920a3c2b6997c7992dee97e8a36d069b1dcbdba))

- Remove custom tailscale options - ([8844ab0](https://github.com/JayRovacsek/nix-config/commit/8844ab057bde3b93c17b2ef9c4d5c30b10ebc201))


### 🚜 Refactor

- *(common,lib)* Remove or standardise some more code - ([76761f5](https://github.com/JayRovacsek/nix-config/commit/76761f5fa162afb7e7dcae33ab37c9aa1424d794))

- *(flake)* Start moving common network to common - ([b274931](https://github.com/JayRovacsek/nix-config/commit/b274931d05e0cfa1d05e62dfcd6ff4593f135927))

- *(flake)* Reorder input attributes - ([891d549](https://github.com/JayRovacsek/nix-config/commit/891d549387fecf8b4e4d8fef5433f82afbab9e17))

- *(flake)* Remove dead config files - ([6392de3](https://github.com/JayRovacsek/nix-config/commit/6392de32ed3764010579c58bda08d0befaaf23b3))

- *(flake)* Rename common.networking to common.config - ([6392de3](https://github.com/JayRovacsek/nix-config/commit/6392de32ed3764010579c58bda08d0befaaf23b3))

- *(flake)* Apply nixfmt-rfc style across all nix code - ([35df3d6](https://github.com/JayRovacsek/nix-config/commit/35df3d69265ff2559b09bd76a4752725cb6b93f5))

- *(flake)* Move to nixfmt-rfc-style - ([e3321be](https://github.com/JayRovacsek/nix-config/commit/e3321be68914028ceb315fe87bf90d82c9149a41))

- *(flake)* Move readme to subfolder - ([8c9a1c7](https://github.com/JayRovacsek/nix-config/commit/8c9a1c7370cf110f394f5aa845e0c1a1176a234b))

- *(home-manager-modules)* Remove redundant firefox ini fixes - ([1b28038](https://github.com/JayRovacsek/nix-config/commit/1b28038c6ae64184847c3f6dcdf466b9fa50bcd5))

- *(home-manager-modules)* Rewrite elements of hyprland module - ([dc1630b](https://github.com/JayRovacsek/nix-config/commit/dc1630b3dd0e0a94e70076b4c89968755ea4fa45))

- *(home-manager-modules)* Remove redundant comment - ([84e9f73](https://github.com/JayRovacsek/nix-config/commit/84e9f73a552d12d1cef31da1d3f57e3c980e1f52))

- *(iac)* Remove disabled assertions from aws image - ([912eae2](https://github.com/JayRovacsek/nix-config/commit/912eae26f5ec106776146709aac9109f015c838b))

- *(linux,overlays)* Minor refactors to remove dead code - ([47fbd99](https://github.com/JayRovacsek/nix-config/commit/47fbd99819cb5ba4d70539610eec2c43218bb2d1))

- *(modules)* Clean up dockutil - ([bf3068a](https://github.com/JayRovacsek/nix-config/commit/bf3068a2689b66e1c43b44766c724a115bfdf9a6))

- *(modules)* Remove extra config element from nix - ([5b906b3](https://github.com/JayRovacsek/nix-config/commit/5b906b3a4063feb585d4548ec8249eb95f483409))

- *(modules)* Minor refactor on dockutil - ([7c40353](https://github.com/JayRovacsek/nix-config/commit/7c403531aeab5ab53dad0db91b3c420033a89fd1))

- *(modules)* Refactor hyprland module - ([f5ffc17](https://github.com/JayRovacsek/nix-config/commit/f5ffc172f53781033c09c39c2a0b70342283e4d8))

- *(modules,home-manager-modules)* Clean up hyprland env vars - ([98b4385](https://github.com/JayRovacsek/nix-config/commit/98b4385fedde6fe00852f2f395d0ef25174a17a9))

- *(modules,home-manager-modules,options)* Align with upstream code - ([cd249fa](https://github.com/JayRovacsek/nix-config/commit/cd249fa1272f118dc68e5cc7f46260b27b834682))

- *(options)* Split options into hm & module segments - ([6c895ad](https://github.com/JayRovacsek/nix-config/commit/6c895ad8af77925d7971e7514e98f4ff5f4fe17d))

- *(options)* Add minimal and all options as exposed common attributes - ([870ca29](https://github.com/JayRovacsek/nix-config/commit/870ca29c00f68e8cfa111e967135448db0426eff))

- *(overlays)* Remove redundant overlays - ([0a4b762](https://github.com/JayRovacsek/nix-config/commit/0a4b76292fc36ca390305ed5ecd1e18c89abe4b2))

- *(overlays)* Remove dead code - ([d07d225](https://github.com/JayRovacsek/nix-config/commit/d07d225d03b2fd8a5842f622dfbd9868ea7d2373))

- *(overlays)* Remove redundant variables - ([d8a39e6](https://github.com/JayRovacsek/nix-config/commit/d8a39e6cc06823b7a69bf19d0e3143baadae7050))

- *(packages)* Remove t2 firmware package - ([c817465](https://github.com/JayRovacsek/nix-config/commit/c817465fb8171f55622f1b59637622058a3ac292))

- *(tools)* Add entries to gitignore - ([98b4385](https://github.com/JayRovacsek/nix-config/commit/98b4385fedde6fe00852f2f395d0ef25174a17a9))
- Remove ai from alakazam - ([f1b1612](https://github.com/JayRovacsek/nix-config/commit/f1b1612094f9e19153ea80534cbf430145fee80d))

- Align comments with upstream terms - ([125adc3](https://github.com/JayRovacsek/nix-config/commit/125adc30ab054a55a5542dab24897b223c136cc0))

- Remove tailscale custom options - ([b5b5cc6](https://github.com/JayRovacsek/nix-config/commit/b5b5cc6ae9fd7450e33117613ee6bfec40d6a663))


### 📚 Documentation

- *(iac)* Regenerate documentation for existing stacks - ([ff3f21a](https://github.com/JayRovacsek/nix-config/commit/ff3f21add9133e09d7d033622093c5f7630e9362))

- *(packages)* Add updated github tfdoc content - ([ece132c](https://github.com/JayRovacsek/nix-config/commit/ece132c1e29217b66bf308414c362674f6161d72))

### 🧪 Testing
- Regenerate hosts to include ip ranges - ([6fde308](https://github.com/JayRovacsek/nix-config/commit/6fde308956417e6062a78675b5b5c7f4272adce0))

## [0.0.8](https://github.com/JayRovacsek/nix-config/compare/v0.0.7..v0.0.8) - 2024-07-21

### ⛰️  Features

- *(common,linux)* Add ironbar home manager set to common - ([3bd1ec9](https://github.com/JayRovacsek/nix-config/commit/3bd1ec96556ca0b09cf7a3173118a898a409e852))

- *(darwin)* Remove keepassxc brew install - ([a27a7f5](https://github.com/JayRovacsek/nix-config/commit/a27a7f5b3555e85f57c6c7cd39699bb0e2ba5e2c))

- *(flake,home-manager-modules)* Remove ags - ([3b340be](https://github.com/JayRovacsek/nix-config/commit/3b340be635892f5a33a88ae8561808d7b6e6ccd3))

- *(home-manager-modules)* Add wlogout module - ([ac27624](https://github.com/JayRovacsek/nix-config/commit/ac27624c8b8555d1e58a7db723387d3ad455523c))

- *(home-manager-modules)* Add hyprlock - ([3fd1e07](https://github.com/JayRovacsek/nix-config/commit/3fd1e07107230aac3f6210159cbb984d1cafe44d))

- *(home-manager-modules)* Integrate colour better with ironbar & hyprland - ([284e1bb](https://github.com/JayRovacsek/nix-config/commit/284e1bbf70b96c674eb690d90dd0d1eadd83326f))

- *(home-manager-modules)* Add ironbar config - ([3b56d70](https://github.com/JayRovacsek/nix-config/commit/3b56d70edbcf379fe05c329fd79eb8d603682b38))

- *(home-manager-modules)* Customise zed theme & settings - ([8111e4f](https://github.com/JayRovacsek/nix-config/commit/8111e4f6ce59c89e505441be202bf4a7e540bcf2))

- *(home-manager-modules)* Add zed home manager module & default settings - ([ecd343e](https://github.com/JayRovacsek/nix-config/commit/ecd343ed6c49efd4479750152a132541947fa071))

- *(home-manager-modules)* Add ollama options for darwin - ([3e98d65](https://github.com/JayRovacsek/nix-config/commit/3e98d65ce27095614a229cab75a4cfdbea352198))

- *(home-manager-modules,darwin)* Add utm as a module - ([83721d3](https://github.com/JayRovacsek/nix-config/commit/83721d30f031b39949f9ad143899cb41d805cd8e))

- *(home-manager-modules,lib)* Add handling for duplicate css keys - ([a2a43e2](https://github.com/JayRovacsek/nix-config/commit/a2a43e2588a1a9cb3654730a5b8a18f172542163))

- *(home-manager-modules,lib)* Nixify ironbar style file - ([a2a43e2](https://github.com/JayRovacsek/nix-config/commit/a2a43e2588a1a9cb3654730a5b8a18f172542163))

- *(hydra)* Add lix to hydra allowed uris - ([a0da1a4](https://github.com/JayRovacsek/nix-config/commit/a0da1a4d4617938fc01ecf8a4b14c16bc6d03552))

- *(iac)* Realign github & add velo-workshop - ([847e76b](https://github.com/JayRovacsek/nix-config/commit/847e76be5e4826305c4dc43e2243c0e497edb395))

- *(linux)* Migrate wigglytuff to impermanence - ([658a820](https://github.com/JayRovacsek/nix-config/commit/658a82073d4c570f8f2a1f00203094767824b4fb))

- *(linux)* Move wigglytuff to impermanence - ([9dd190a](https://github.com/JayRovacsek/nix-config/commit/9dd190afe3dfb197632d3032876b470481ad312e))

- *(linux)* Remove swapfile on jigglypuff & use pi3 kernel - ([d04a417](https://github.com/JayRovacsek/nix-config/commit/d04a41767e4197ccc7972ec36e4daebc9e597fd3))

- *(linux,modules,home-manager-modules)* Migrate jigglypuff to impermanence - ([a11c706](https://github.com/JayRovacsek/nix-config/commit/a11c706bb9d8364086a2e67bb13e826a818af5cd))

- *(modules)* Add ollama module - ([3e8f773](https://github.com/JayRovacsek/nix-config/commit/3e8f773313b302b4b290121f27f9968925ba354b))

- *(modules)* Add systemd-boot module - ([15d8754](https://github.com/JayRovacsek/nix-config/commit/15d875473a2d8eace6a7802bc737fdbece30009a))

- *(modules,common,linux)* Resolve unifi not being nixified - ([6e6c9c2](https://github.com/JayRovacsek/nix-config/commit/6e6c9c2e439d4ad02c2c8f1e6325e3ee787d2ae9))

- *(modules,linux,darwin)* Add lix to modules & implement for some hosts - ([a696b74](https://github.com/JayRovacsek/nix-config/commit/a696b74f57fe85ca3da2c25858eb95ffbe41d78c))

- *(modules,options)* Implement velociraptor modules - ([d4d1471](https://github.com/JayRovacsek/nix-config/commit/d4d1471108d1c67444e5556c330daf22cb0d4122))

- *(options,darwin)* Re-add user ollama service on darwin - ([7b267ac](https://github.com/JayRovacsek/nix-config/commit/7b267acc31af0adc20554450c7df01725109c851))

- *(packages)* Add velociraptor package - ([bb4ba58](https://github.com/JayRovacsek/nix-config/commit/bb4ba58ad18e2b95e0b84d9128747f56bd363a65))
- Update nix-options to 24.05 also - ([fab8c60](https://github.com/JayRovacsek/nix-config/commit/fab8c60c1629c0966a45665aff68ab4e208a4cf1))


### 🐛 Bug Fixes

- *(flake)* Resolve dead inputs - ([69f5b1b](https://github.com/JayRovacsek/nix-config/commit/69f5b1b1babef57bbac59e91685636bb44810bc7))

- *(home-manager-modules)* Remove old config option from hyprland - ([63cd7b1](https://github.com/JayRovacsek/nix-config/commit/63cd7b125c5b6976217b4e161202036b5d1c1ad9))

- *(home-manager-modules)* Add notifications, shift mem and temp interval - ([28f3b8d](https://github.com/JayRovacsek/nix-config/commit/28f3b8d90c66fd5e76ad7a67d06ffe7867a78eab))

- *(home-manager-modules)* Resolve issue with tuigreet holding old hyprland sesh - ([430b9b6](https://github.com/JayRovacsek/nix-config/commit/430b9b68e29a2ec64229b3eb5080330b6725efcc))

- *(home-manager-modules)* Correct path for zed settings - ([af2d887](https://github.com/JayRovacsek/nix-config/commit/af2d8873c489fb4275b0803c604ada49c3a95fd2))

- *(home-manager-modules)* Remove python from vscode - ([f49e4b4](https://github.com/JayRovacsek/nix-config/commit/f49e4b415f2f80990f50b5fd046137885a594deb))

- *(home-manager-modules)* Resolve ollama issues - ([69f5b1b](https://github.com/JayRovacsek/nix-config/commit/69f5b1b1babef57bbac59e91685636bb44810bc7))

- *(home-manager-modules)* Resolve vscode plugin issues - ([69f5b1b](https://github.com/JayRovacsek/nix-config/commit/69f5b1b1babef57bbac59e91685636bb44810bc7))

- *(linux)* Add fuse allow other for jigglypuff - ([e9de8fc](https://github.com/JayRovacsek/nix-config/commit/e9de8fcca3dc245ae487af33a8493944da7a90bc))

- *(linux)* Correct impermanence on jigglypuff - ([7e0b548](https://github.com/JayRovacsek/nix-config/commit/7e0b548347634f65ee44a23daa853613204f7089))

- *(linux)* Move alakazam to systemd boot - ([15d8754](https://github.com/JayRovacsek/nix-config/commit/15d875473a2d8eace6a7802bc737fdbece30009a))

- *(modules)* Resolve removed opengl option - ([e7678ef](https://github.com/JayRovacsek/nix-config/commit/e7678efaefbdbf470d9c861f4997744bbd7eb44f))

- *(modules)* Add ssh directory to impermanence mounts - ([9dd190a](https://github.com/JayRovacsek/nix-config/commit/9dd190afe3dfb197632d3032876b470481ad312e))

- *(modules)* Resolve loki v12 -> v13 changes - ([0f18ebf](https://github.com/JayRovacsek/nix-config/commit/0f18ebf54033e291bee32bf52171676514563862))

- *(modules,home-manager-modules)* Remove vulkan from hyprland - ([115f75f](https://github.com/JayRovacsek/nix-config/commit/115f75fada8a465e2bb47e5c1e801a4e37c8d432))

- *(options)* Shift dock-util to binary source to avoid issues with swift - ([522d43e](https://github.com/JayRovacsek/nix-config/commit/522d43e80061aaa29e5a4079596313cba233c62c))

- *(overlays)* Update keepassxc overlay version - ([69f5b1b](https://github.com/JayRovacsek/nix-config/commit/69f5b1b1babef57bbac59e91685636bb44810bc7))

- *(packages)* Resolve deterministic cert not including base domain - ([0afb74c](https://github.com/JayRovacsek/nix-config/commit/0afb74ca93907a581c294ff4ae36faac26efcda3))
- Move impermanence to it's own package set - ([13d0b9e](https://github.com/JayRovacsek/nix-config/commit/13d0b9e58eba90afdb035163f4f23b2f0cbfccc2))

- Resolve eval issues - ([b8e346d](https://github.com/JayRovacsek/nix-config/commit/b8e346d910a1b087960f4bb2dd796fd3209f160d))

- Resolve missing module file - ([b87be83](https://github.com/JayRovacsek/nix-config/commit/b87be83443f655ba1cfb8c809ea89477c0b0981e))

- Resolve vscodium issues on aarch64-linux - ([e283bcb](https://github.com/JayRovacsek/nix-config/commit/e283bcbb81b23ebc9d35aadf01e7e74ff4baa5dc))

- Resolve ollama issues on linux by disabling for now - ([b00ccff](https://github.com/JayRovacsek/nix-config/commit/b00ccff6fe01ee97d68337aaa60bbae47717b38c))


### 🚜 Refactor

- *(checks)* Remove custom trufflehog check - ([a696b74](https://github.com/JayRovacsek/nix-config/commit/a696b74f57fe85ca3da2c25858eb95ffbe41d78c))

- *(linux)* Remove a large chunk of dead or redundant code - ([658a820](https://github.com/JayRovacsek/nix-config/commit/658a82073d4c570f8f2a1f00203094767824b4fb))

- *(modules)* Simplify fonts module - ([bc22ac0](https://github.com/JayRovacsek/nix-config/commit/bc22ac036029b34e674bf43eb1cb85a64111cda0))
- Reorder inputs - ([21d0ebd](https://github.com/JayRovacsek/nix-config/commit/21d0ebde647dfec1b065f74c3b9bb43810873041))

## [0.0.7](https://github.com/JayRovacsek/nix-config/compare/v0.0.6..v0.0.7) - 2024-05-19

### ⛰️  Features

- *(apps,packages)* Remove package content from apps file - ([a8ff962](https://github.com/JayRovacsek/nix-config/commit/a8ff962836b45ac082a807eb3d756f217cbe8700))

- *(common)* Add standard aarch64 image - ([d106da7](https://github.com/JayRovacsek/nix-config/commit/d106da736bc59bff805e69832f0a3d22f06bb44c))

- *(common)* Generate and add keys for all suitable hosts - ([6d582d9](https://github.com/JayRovacsek/nix-config/commit/6d582d96d5ce3cb8f3779348ee216c71c5565518))

- *(home-manager-modules)* Move from arrterian.nix-env-selector to mkhl.direnv - ([c149982](https://github.com/JayRovacsek/nix-config/commit/c149982e54ac3974ec1813399a2a729d13e6662e))

- *(home-manager-modules)* Add success logging to firefox config - ([3373f48](https://github.com/JayRovacsek/nix-config/commit/3373f48031514927ce8236534b6b5dc56fc245f7))

- *(linux)* Add smartd options for exos drives - ([ba2c8a6](https://github.com/JayRovacsek/nix-config/commit/ba2c8a6b84c1d24eccec58a93ae57a5f493e58b6))

- *(linux)* Implement local and remote backups for nextcloud in nix - ([1728f77](https://github.com/JayRovacsek/nix-config/commit/1728f77d4d1d088b753ab2379b306cbb9169655e))

- *(linux)* Correct disko config for dragonite - ([7d71a2b](https://github.com/JayRovacsek/nix-config/commit/7d71a2bda559ac8fb02a75ab7e7ca55085dd4aca))

- *(linux)* Move alakazam to tmp on tmpfs - ([95d9073](https://github.com/JayRovacsek/nix-config/commit/95d907323f90b0290709ab5b82873d56d922748a))

- *(linux)* Add new disk to dragonite zfs pool - ([74e639a](https://github.com/JayRovacsek/nix-config/commit/74e639a2f2273dd5499248ce9c8fa85fd548b440))

- *(linux)* Add smartd & tmp-tmpfs to dragonite - ([62cb429](https://github.com/JayRovacsek/nix-config/commit/62cb429e52126b4685979b26f4b5958fc9d947b1))

- *(linux,flake)* Add sandro nixos modules input + nextcloud options - ([f9a4aba](https://github.com/JayRovacsek/nix-config/commit/f9a4aba7a6f80440614ad8e9d82822266cc89ba7))

- *(modules)* Add gnome-keyring module - ([fd39b5f](https://github.com/JayRovacsek/nix-config/commit/fd39b5fc7225ec58ba8ef28b1fff872e9771c3f2))

- *(modules)* Implement nginx status page & monitoring - ([eafeee1](https://github.com/JayRovacsek/nix-config/commit/eafeee16a0d3dff2752e1e1207a350759b39a1bc))

- *(modules)* Implement tmpfs module for /tmp - ([f9a4aba](https://github.com/JayRovacsek/nix-config/commit/f9a4aba7a6f80440614ad8e9d82822266cc89ba7))

- *(modules)* Add nextcloud dashboard - ([ab4d70a](https://github.com/JayRovacsek/nix-config/commit/ab4d70aff530f6328d83c7a1c2f15819d25fdf5d))

- *(modules,linux)* Add logs backup configuration - ([04f4666](https://github.com/JayRovacsek/nix-config/commit/04f4666939509515e5713e8ba0c392f72dedc81f))

- *(packages)* Add AnythingLLMDesktop - ([6766355](https://github.com/JayRovacsek/nix-config/commit/67663552bd18150e56ced05773551a567422e1d6))

### 🐛 Bug Fixes

- *(home-manager-modules)* Remove neovim telescope settings - ([62cb429](https://github.com/JayRovacsek/nix-config/commit/62cb429e52126b4685979b26f4b5958fc9d947b1))

- *(home-manager-modules,overlays)* Resolve keepassxc issues with yubikey - ([6576768](https://github.com/JayRovacsek/nix-config/commit/65767689c9fc579e56ef0509ce4c1869a1ed8f25))

- *(linux)* Re-add code server, remove porygon from dragonite - ([dffdfc8](https://github.com/JayRovacsek/nix-config/commit/dffdfc826f357f6dc2248979e05756d9512fe340))

- *(linux)* Resolve problematic microvm ram issues - ([a192776](https://github.com/JayRovacsek/nix-config/commit/a1927760e69e345c4dc25455dd4afc3086804060))

- *(linux)* Resolve regression issue introduced with recent common changes - ([30cc12a](https://github.com/JayRovacsek/nix-config/commit/30cc12ae25bb1442fe5a825b487f390ba027731d))

- *(modules)* Add allowed uri to hydra - ([ad37c0c](https://github.com/JayRovacsek/nix-config/commit/ad37c0c6ded4e7a0181c706f723e097132fcfc1b))

- *(modules)* Resolve acme issues providing cert to domain root - ([97bff0a](https://github.com/JayRovacsek/nix-config/commit/97bff0ad51bf9ef82898333dc0b33248f30dbb19))

- *(modules)* Resolve dockutil definition for keepassxc - ([2e20f48](https://github.com/JayRovacsek/nix-config/commit/2e20f483aa224c43731d73b41933e4f0d55490b5))

- *(modules)* Make environment variable default for GDK on wayland - ([06b21d1](https://github.com/JayRovacsek/nix-config/commit/06b21d178fbcc158bec6397215a09a572b54e24b))

- *(modules)* Resolve hydra eval issues - ([6a1826e](https://github.com/JayRovacsek/nix-config/commit/6a1826e60fd7de12e7aecd48cec32e1f4851caaf))

- *(modules)* Resolve firefox sync service configuration - ([24d52cb](https://github.com/JayRovacsek/nix-config/commit/24d52cb9f3fb9a0f21ed1d2f4e48e282d9315408))

- *(modules)* Revert to wildcard primary name, tld extra names in acme - ([1f3c452](https://github.com/JayRovacsek/nix-config/commit/1f3c4522120d64729590ced3e194261a261762c4))

- *(modules)* Remove notify action from clamav - achieved by loki instead - ([8afd672](https://github.com/JayRovacsek/nix-config/commit/8afd67244c15b941c9c4ef7f1e987e9f33e75560))

- *(modules)* Add tags to grafana dashboards, add - ([ab4d70a](https://github.com/JayRovacsek/nix-config/commit/ab4d70aff530f6328d83c7a1c2f15819d25fdf5d))

- *(modules,common,linux)* Move authelia network to simply auth - ([48c0bf0](https://github.com/JayRovacsek/nix-config/commit/48c0bf042f744bceaeebe8afa51edb49d89a7d04))

- *(modules,home-manager-modules)* Resolve issues introduced with nix-ide update - ([187c9e0](https://github.com/JayRovacsek/nix-config/commit/187c9e0c36da270847383fe18c614693ca6ff83b))

- *(modules,home-manager-modules)* Resolve hyprland env issues - ([fbe3b23](https://github.com/JayRovacsek/nix-config/commit/fbe3b2386486bf95b5c9b02a0f6cbf267c331cb8))

- *(modules,hydra)* Add more trusted uris - ([9ac9f55](https://github.com/JayRovacsek/nix-config/commit/9ac9f5503d07485fc4d761b747460a946389f1b0))

- *(modules,hydra)* Resolve status updates on PRs - ([1c00211](https://github.com/JayRovacsek/nix-config/commit/1c00211ff811610f483eb733f52c8c3b2f03fdeb))

- *(modules,linux)* Remove blocky from magikarp, add custom dns as optional map - ([d000a69](https://github.com/JayRovacsek/nix-config/commit/d000a69fb539d0fa6e286586e232f9416aac7285))

- *(options)* Resolve sonarr authentication methods - ([6086aec](https://github.com/JayRovacsek/nix-config/commit/6086aec4d4521d08f4d26fed7dedb139d682d311))

- *(overlays)* Resolve jellyfin on hyprland issues - ([ad37c0c](https://github.com/JayRovacsek/nix-config/commit/ad37c0c6ded4e7a0181c706f723e097132fcfc1b))

- *(packages)* Resolve eval issue for packages - ([440ddec](https://github.com/JayRovacsek/nix-config/commit/440ddec0b07c7e881e2bc6d80f5412f8fa91a390))

- *(secrets)* Resolve incorrect creds in acme env - ([a7ab682](https://github.com/JayRovacsek/nix-config/commit/a7ab682077c2f27b4e9609f4444d19b12f5244be))

- *(tooling)* Resolve typos not using packaged defined config - ([6d582d9](https://github.com/JayRovacsek/nix-config/commit/6d582d96d5ce3cb8f3779348ee216c71c5565518))
- Correct backup to ensure unlock prior to run - ([77f8d41](https://github.com/JayRovacsek/nix-config/commit/77f8d410acf9fd7a8ab8cb909e65f7aa29e59ba4))

- Resolve removed typos config from apps - ([d0fe627](https://github.com/JayRovacsek/nix-config/commit/d0fe6277cee1a79b3aecd95fb2e6d934b798c52d))

- Resolve regression with jellyfin on hyprland - ([7dae711](https://github.com/JayRovacsek/nix-config/commit/7dae711a1b70e765464deeb20f8d5d8ec6a7f6f3))


### 🚜 Refactor

- *(flake)* Change devshell to packages rather than commands - ([5ae35d7](https://github.com/JayRovacsek/nix-config/commit/5ae35d7e345d5eee37bc4d85c2d06b5fc7b51043))

- *(linux)* Reorder alakazam modules - ([95d9073](https://github.com/JayRovacsek/nix-config/commit/95d907323f90b0290709ab5b82873d56d922748a))

- *(linux)* Reorder modules in dragonite imports - ([74e639a](https://github.com/JayRovacsek/nix-config/commit/74e639a2f2273dd5499248ce9c8fa85fd548b440))

- *(linux)* Remove old-users.nix from dragonite - ([759c05b](https://github.com/JayRovacsek/nix-config/commit/759c05b4529a808b195a5b4f77245833b20d0573))

- *(packages)* Swap use of sha256 to hash - ([0402c7d](https://github.com/JayRovacsek/nix-config/commit/0402c7d55559607b1c4dc536fcaf0cc1afdd629c))

- *(packages)* Remove cpp packages (upstream'd) - ([0402c7d](https://github.com/JayRovacsek/nix-config/commit/0402c7d55559607b1c4dc536fcaf0cc1afdd629c))

- *(packages)* Remove redundant platforms definitions - ([079603e](https://github.com/JayRovacsek/nix-config/commit/079603ee6056e044ee09f79401a11a01700729fc))

- *(packages)* Restructure more packages to match upstream expected order - ([079603e](https://github.com/JayRovacsek/nix-config/commit/079603ee6056e044ee09f79401a11a01700729fc))
- Remove some redundant code - ([ad37c0c](https://github.com/JayRovacsek/nix-config/commit/ad37c0c6ded4e7a0181c706f723e097132fcfc1b))


### 📚 Documentation
- Generate deployment svg - ([a39aa02](https://github.com/JayRovacsek/nix-config/commit/a39aa024e91290656d1185158b9c3d7e8cef315a))

## [0.0.6](https://github.com/JayRovacsek/nix-config/compare/v0.0.5..v0.0.6) - 2024-04-22

### ⛰️  Features

- *(common)* Add basic nix topology diagram of configurations - ([6a27732](https://github.com/JayRovacsek/nix-config/commit/6a2773261989b04cb6ab9aa0d6b5a0bb023dd9fc))

- *(common)* Add vlan definitions to common code - ([6d515c9](https://github.com/JayRovacsek/nix-config/commit/6d515c9a485d31a3dd51b828fe0141deb446d991))

- *(flake)* Add disko input - ([3b8779c](https://github.com/JayRovacsek/nix-config/commit/3b8779c63b485b240d47e18ada5d43db63138559))

- *(flake)* Add nix-topology to inputs - ([e2b1703](https://github.com/JayRovacsek/nix-config/commit/e2b17036e6d8ead8ad419f48d3e11f8271012b47))

- *(linux)* Migrate dragonite's zfs disks to disko (currently degraded) - ([3b8779c](https://github.com/JayRovacsek/nix-config/commit/3b8779c63b485b240d47e18ada5d43db63138559))

- *(linux)* Add grafana agent more widely over deployed hosts - ([5c7278c](https://github.com/JayRovacsek/nix-config/commit/5c7278cdbc33a8f17dfd9640cc329c5155ed3fd3))

- *(linux)* Add grafana server root url to mr-mime - ([52ebe77](https://github.com/JayRovacsek/nix-config/commit/52ebe7730cc17d34f9eac51b0197a52673789e0a))

- *(linux)* Add nix-topology module to all nixos systems - ([9cdc214](https://github.com/JayRovacsek/nix-config/commit/9cdc214deb256b2d15c3eaccd13a3703cdaed886))

- *(modules)* Add a number of dashboards to grafana as code - ([2a6aacc](https://github.com/JayRovacsek/nix-config/commit/2a6aaccaabae8b11d561d6ee006f3d613169611f))

- *(modules)* Implement tmux - ([078945f](https://github.com/JayRovacsek/nix-config/commit/078945f85d4e18c116c5988901a480251a60e065))

- *(modules)* Add nextcloud node exporter - ([07dc034](https://github.com/JayRovacsek/nix-config/commit/07dc0345d589be656b9bab5694c83072e4e97ac4))

- *(modules)* Add more scraped services to grafana agent - ([5c7278c](https://github.com/JayRovacsek/nix-config/commit/5c7278cdbc33a8f17dfd9640cc329c5155ed3fd3))

- *(modules)* Implement smartd module - ([cae7614](https://github.com/JayRovacsek/nix-config/commit/cae761465a98c19861e1bbb8668b9bc0c879a4d8))

- *(modules)* Implement nix-topology module - ([9cdc214](https://github.com/JayRovacsek/nix-config/commit/9cdc214deb256b2d15c3eaccd13a3703cdaed886))

- *(packages)* Re-introduce flask-security - ([ecd6dc7](https://github.com/JayRovacsek/nix-config/commit/ecd6dc7ec46c3e1440b8071f5b093690d2752cd3))

- *(packages)* Add topology to exported packages - ([dfff01f](https://github.com/JayRovacsek/nix-config/commit/dfff01ff3d208991af3e1acecfa530f4b6bafe6c))

- *(packages)* Implement pf and ub logos - ([0b598d7](https://github.com/JayRovacsek/nix-config/commit/0b598d78cff2d8deaf171acebdaed95f90f1742d))

### 🐛 Bug Fixes

- *(flake)* Change nix-topology input away from local dev - ([310343b](https://github.com/JayRovacsek/nix-config/commit/310343b09bfeaf0a1a7d762cdbe88153cdc9ba1e))

- *(home-manager-modules)* Change keepassxc default open behaviour - ([89a498c](https://github.com/JayRovacsek/nix-config/commit/89a498ca0b059cb08210f091abc46f79a742e864))

- *(home-manager-modules)* Correct screen positions for alakazam again - ([da9c289](https://github.com/JayRovacsek/nix-config/commit/da9c289fc8768d5e511b55f773944c015a013f63))

- *(linux)* Add missing modules from wigglytuff - ([ff41272](https://github.com/JayRovacsek/nix-config/commit/ff41272c427ec46fe985b2074ad69e09e522ce08))

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

### 🐍 Hydra

- *(packages)* Remove topology from packages - ([0889862](https://github.com/JayRovacsek/nix-config/commit/08898627fdab8f7a62a03cd7471d8a2119666bef))

### 🚜 Refactor

- *(flake)* Move devshell code to main flake file - ([a1beeb0](https://github.com/JayRovacsek/nix-config/commit/a1beeb0c719aebfb02cf42a76e2c3731570b16ef))

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

### 🐍 Hydra

- *(hydra)* Remove checks from hydra jobs - ([2e7233d](https://github.com/JayRovacsek/nix-config/commit/2e7233de66f7b4abd0ad655c02cc43ae51d849a1))

### 🚜 Refactor

- *(apps)* Remove act app - ([3e900ab](https://github.com/JayRovacsek/nix-config/commit/3e900abcba82611d33094f1917bc5f09a572167d))

- *(home-manager-modules)* Implement mopidy in hm rather than system - ([d3ed33e](https://github.com/JayRovacsek/nix-config/commit/d3ed33ef9b99b5f1691279f762c50d8f51627422))

### 📚 Documentation

- *(hydra)* Add comments to hydra required allowed uris - ([8ccf002](https://github.com/JayRovacsek/nix-config/commit/8ccf002f3c6627e92c30b16c4f31e6dd786b6f41))

### 🧪 Testing

- *(linux)* Swap alakazam back to waybar for now - ([3e900ab](https://github.com/JayRovacsek/nix-config/commit/3e900abcba82611d33094f1917bc5f09a572167d))

### ⚫ Common

- *(modules)* Resolve eval error - ([4cf0320](https://github.com/JayRovacsek/nix-config/commit/4cf0320c34788f5aeb0078483b7e8ef8dd503a7c))
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
## [0.0.1](https://github.com/JayRovacsek/nix-config/compare/v0.0.0..v0.0.1) - 2024-02-11

### 🧪 Testing
- Test branch protection - ([2dbb0ac](https://github.com/JayRovacsek/nix-config/commit/2dbb0ace6e749093f083aeaf63897c1ecd961798))

- Test - ([e448584](https://github.com/JayRovacsek/nix-config/commit/e4485847a90823ce1158b69543c6e4e36d83b63c))


