# nix-config

![Endpoint Badge](https://img.shields.io/endpoint?url=https%3A%2F%2Fhydra.rovacsek.com%2Fbadge%2Fnix-config%2Fmain&style=for-the-badge&cacheSeconds=60&link=https%3A%2F%2Fhydra.rovacsek.com%2Fjobset%2Fnix-config%2Fmain%2Flatest-eval)

![Endpoint Badge](https://img.shields.io/endpoint?url=https%3A%2F%2Fhydra.rovacsek.com%2Fbadge%2Fnix-config%2Fstaging&style=for-the-badge&cacheSeconds=60&link=https%3A%2F%2Fhydra.rovacsek.com%2Fjobset%2Fnix-config%2Fstaging%2Flatest-eval)

![Endpoint Badge](https://img.shields.io/endpoint?url=https%3A%2F%2Fhydra.rovacsek.com%2Fbadge%2Fnix-config%2Ftesting&style=for-the-badge&cacheSeconds=60&link=https%3A%2F%2Fhydra.rovacsek.com%2Fjobset%2Fnix-config%2Ftesting%2Flatest-eval)

![What in tarnation](https://github.com/JayRovacsek/ncsg-presentation-feb-2022/blob/main/resources/what-in.jpg?raw=true)

This repo contains my flake'd nix configs

Note that while flakes are a beautiful thing in which we could have many repositories to then bind together via inputs & make configurations
far more contained in each repository, this is intentionally a mono-flake.

It includes overlays, packages and configurations for both linux and darwin
hosts to centralise the configuration where possible.

In terms of deployed resources; [nix-topology](https://github.com/oddlama/nix-topology) will have saved me countless hours diagramming the deployment within this repository. Their hard work is very appreciated!

Notes about deployment diagram:

- nix-topology does not currently render all services in use, but does do a great job in presenting the more common services thus far & is awesome in engaging proposed changes that would benefit the community
- the diagram is centred around my home-lab only. Configurations that deploy to AWS, Linode and more exist but are excluded from the diagram for now

![Topology of Deployment](../resources/deployment.svg)

## Why?

Computers are good at doing exactly what we tell them to do. By
declaring all that exists within my home-lab as declarative and
reproducible code, I build the configuration, (re)deployment and
documentation all in one go.

If you're here, you likely already use nix, but if you don't;
take a chance on it: if it doesn't break your current mental model
of the operationalisation of computing I'd be surprised

![Would I recommend nixos?](../resources/recommend.jpg)
