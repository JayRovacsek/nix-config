# onix

Orange Pi 5 Plus (aarch64, Rockchip RK3588) configured to boot a NixOS image
built with [disko].

## Image layout

The image is a full-disk GPT image with two partitions:

| Partition  | Type                           | Size         | Format | Mountpoint |
| ---------- | ------------------------------ | ------------ | ------ | ---------- |
| boot (ESP) | `EF00` (EFI System)            | 1G           | vfat   | `/boot`    |
| root       | `B921B045` (Linux root ARM-64) | rest of disk | ext4   | `/`        |

The bootloader is **systemd-boot** (UEFI), installed to the ESP's removable
fallback path `/EFI/BOOT/BOOTAA64.EFI` so the board's UEFI firmware
(TianoCore) finds it automatically. `boot.growPartition` expands the root
partition to fill the disk on first boot.

## Build the image

```console
nix build .#nixosConfigurations.onix.config.system.build.diskoImages
```

This cross-builds the image on an `x86_64-linux` host using disko's image
builder: `disko.imageBuilder.pkgs` is pinned to the `x86_64-linux-unstable`
package set, with binfmt emulation for the aarch64 installer step. The result
is a raw disk image at `result/rootfs.raw`.

A runnable script variant is also available:

```console
nix build .#nixosConfigurations.onix.config.system.build.diskoImagesScript
```

## Write the image to a drive

Confirm the target NVMe device first (`lsblk`), then write the whole image to
the raw device (not a partition):

```console
sudo dd if=result/rootfs.raw of=/dev/nvme0n1 bs=4M conv=fsync status=progress
```

Replace `/dev/nvme0n1` with the actual device. This destroys all data on the
target drive.

## First boot

Set the board to boot from **NVMe rather than the SD card** — either in the
UEFI (TianoCore) firmware's boot order, or the board's boot device selector.
