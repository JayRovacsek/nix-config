# nix-config

![What in tarnation](https://github.com/JayRovacsek/ncsg-presentation-feb-2022/blob/main/resources/what-in.jpg?raw=true)

This repo contains my flake'd nix configs

Note that while flakes are a beautiful thing in which we could have many repositories to then bind together via inputs & make configurations
far more contained in each repository, this is intentionally a mono-flake. It includes overlays, packages and configurations for both linux and darwin
hosts to centralise the configuration and possibly help myself and/or viewers understand the spiderweb of \*.nix files.

![Would I recommend nixos?](./resources/recommend.jpg)
