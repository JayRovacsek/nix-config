# Jigglypuff
Hardware: Raspberry Pi3

Function: Internal DNS Resolver, accepting on 53, pushing over to stubby to be resolved via DoTLS

## Significant Differences
This host does not apply the default aarch `nix.*` options, opting instead to disable features regarding store or gc optimisations.
This is because the host appeared to fail overnight and profiling suggested a lack of RAM - given the default auto optimisation and GC options are set to 03:15 we're pretty confident this should resolve the issue.

This instance also lacks clamav due to RAM limitations. Firewalling and network segmentation _should_ provide some protections. 
