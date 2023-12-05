# TODO

A simple list of stuff that I need to do/explore but don't trust my memory to
serve me well.

- Implement disko (https://github.com/nix-community/disko)
- Explore fragmenting this repo to reduce amount of code present in here that isn't system configuration
- Look to expand impertenance (https://github.com/nix-community/impermanence) to create more ephemeral environments for desktops and servers
- Look at if there is ways to speed up current eval of systems (flake recursion :sadpanda:)
- neovim setup - HM module is a stub and would be good to expand this and replace VScode possibly

- Get moonlight working as a module, fixing existing hardware decode issues (https://github.com/moonlight-stream/moonlight-docs/wiki/Fixing-Hardware-Decoding-Problems)
- Setup sunshine streaming: https://github.com/devusb/nix-config/blob/50055dcc9cc567ab4585ffe88b6e9a8505234409/modules/nixos/sunshine.nix#L6
- Look into ryujinx
- Fix suspend on hyprland losing user session (windows gone etc etc)
- Declaratively manage keepass (https://github.com/kira-bruneau/home-config/tree/main/package/keepassxc)
- Reevaluate how SSH configs are generated + remote builds - they're slow AF currently due to the need to evaluate all system configs
- styx implementation for documentation
- agenix move some secrets into home module
- get nixos on droid working

WIP but not done:

- SBOM generation
- Microvms
  - nix containers might be better here
- ZTA networking via tailscale/headscale
- Expand cloud images deployable
- Replace SWAG with nix native configuration and deployment

Dig into https://docs.robotnix.org/options.html
https://github.com/cyber-murmel/NixOS-on-ARM-Examples/tree/main

services.endlessh.enable
