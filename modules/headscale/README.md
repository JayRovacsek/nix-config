# Headscale
This markdown really only exists to remind me what/how I've done here.

## Generating Headscale's Private Key

```sh
nix-shell -p wireguard-tools
wg genkey > .private.key
agenix -e headscale_private_key.age
```