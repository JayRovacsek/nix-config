# nix-config

![What in tarnation](https://github.com/JayRovacsek/ncsg-presentation-feb-2022/blob/main/resources/what-in.jpg?raw=true)

This repo contains my flake'd nix configs, it's a work in progress and currently being migrated to from [my old configs](https://github.com/JayRovacsek/dotfiles)

Note that while flakes are a beautiful thing in which we could have many repositories to then bind together via inputs & make configurations
far more contained in each repository, this is intentionally a mono-flake. It includes overlays, packages and configurations for both linux and darwin
hosts to centralise the configuration and possibly help myself and/or viewers understand the spiderweb of *.nix files.

## Using this/something like this

Bootstrap yourself some Nix, ensure you've got flake support and then depending on if you're using Linux or Darwin modify the relevant nixosConfigurations/darwinConfigurations

Note that in building/switching to the config you're after you'll need to either define _what_ config you're using or ensure the name of the config matches your target system hostname.

To arbitrarily test/dry-build a config you can use standard flake pathing, for example on a linux system:

```sh
# Match on hostname
nixos-rebuild dry-build --flake .# 
# Build alakazam
nixos-rebuild dry-build --flake .#alakazam 
```

Of-course these could just be tested using the subcommand for `nixos-rebuild` of `test`.

```sh
# Match on hostname
nixos-rebuild test --flake .#
# Test alakazam
nixos-rebuild test --flake .#alakazam 
```

## Fearless Refactor
Historically there is a fear of updates due to how they've been breaking in various ways for a number of common systems. Generations save us here in
this aspect, but what if I want to refactor large swathes of my nix code and be certain I haven't changed the status-quo for the most part?

It seems thus far in my testing you could abuse a small amount of disk space to be _really_ confident in refactor efforts, firstly make sure you create a branch 
for your work in progress, then create any number of changes. Copy the repo to another folder (to be honest this is likely possible to do in the single folder 
and I'm just yet to read the docs far enough), checkout the work you want to compare in one folder and the original work in another then:
```sh
# Old -> New
nix store diff-closures ../nix-config-tmp#nixosConfigurations.HOST.config.system.build.toplevel .#nixosConfigurations.HOST.config.system.build.toplevel --no-write-lock-file > output
```

Note; if the systems utilise new package versions those of-course will be downloaded for comparison, but otherwise this should be relatively like-for-like
if you were to not modify the flake inputs otherwise.

## Debugging

If you also have spent countless hours just wanting to do and not RTFM like I have, you might want to utilise the repl and/or `builtins.trace` when the time comes.

To load this (or any flake via the repl):

```sh
nix repl # You should be in a repl now, ensure you remember exit is Ctrl + D

:lf . # Period here is just the path to a directory containing a flake. Here we assume it is in $PWD

# An example; to look at what vlans exist of jigglypuff:
nixosConfigurations.jigglypuff.options.networking.vlans.value

# Which should return the below at time of writing
{ dns = { ... }; }

# Delving deeper on this is easy as using shell history and tabbing for auto-complete
nixosConfigurations.jigglypuff.options.networking.vlans.v
alue.dns.interface

# For darwin configs, example of exploring the options applied against cloyster:
darwinConfigurations.cloyster.options
```

# Todo

Having more time would be great, for now I'll try capture some ideas/goals of what future state I'd like to get to using Nix.

Current list:

- ~Have home-manager configs generate per standard user on a system rather than binding to "jay" / "jrovacsek" based on OS type. There are already examples of this but my first attempt in grokking a scalable approach failed. As a note for future self; the following does give current users however when joined with a `home-manager.users.${x}.programs.*` it appears to suffer infiinite recursion.~ DONE
- ~Flake my home server~ DONE
- ~Manage secrets within the configs (gitcrypt? borg? morph? ¯\\_\(ツ)\_/¯ )~ [long live agenix!](https://github.com/JayRovacsek/nix-config/tree/main/secrets)
- Start template directory for shell.nix files to start the process of removing explicitly installed dev dependencies
- ~SSH Management (yubikey based, get hosts to understand those juicy pub/priv keypairs without generating a trillion of them, death to password SSH)~
- GPG signing for git automatically configured by nix across Linux and Macos
- Elasticsearch implementation to gather, munge and query logs from all compute
- ~[Headscale](https://search.nixos.org/options?channel=unstable&from=0&size=50&sort=relevance&query=headscale) + client configs to implement a true zero-trust network within compute I control. This removes bounds of hosts needing to run inside of network segments that aren't captured by nix configs (unless nixos as a router becomes a thing)~
- ~Dig into the usability of [microvms](https://github.com/astro/microvm.nix) to avoid use of docker where possible. This is not because docker is bad, but instead to enable reuse of existing modules within these configs - afterall, why bother having a [clamav module](./modules/clamav/default.nix) if you can't deploy it to all your compute~
- Dig into nixos as a router ([eg](https://francis.begyn.be/blog/nixos-home-router))
- ~Implement vGPU for nvidia~ Done in a branch, however blocked as it turns out the drivers are not publicly available so either do illegal stuffs and get that driver (yeah, nah) or pay for it :cry:
- Look into deploying armv7 instances of nixos to:
  - ~RaspberryPi Zero (w and not)~ Done as exported package: rpi1 / rpi2
  - ~RaspberryPi 2 (Igglybuff if we can get this going - get that sucker to run as an internal DNS node)~ ~ Done as exported package: rpi1 / rpi2
  - OrangePi Lite
  - OrangePi Plus v2
  - OrangePi Winplus
- Automate flake updates (well, git pull/nixos rebuild) as a system service on all devices

I'm totally missing some ideas, hopefully I'll add them with related links as they come back into my head.

![Would I recommend nixos?](./resources/recommend.jpg)
