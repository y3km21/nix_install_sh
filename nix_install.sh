#!/run/current-system/sw/bin/bash

# --Parted
# BIOS/GPT
# make gpt partition table
sudo parted /dev/sda -- mklabel gpt
# add root partition
sudo parted /dev/sda -- mkpart primary 100MiB -4GiB
# add swap partition
sudo parted /dev/sda -- mkpart primary linux-swap -4GiB 100%
# add boot partition
sudo parted /dev/sda -- mkpart primary 1MiB 100MiB
sudo parted /dev/sda -- set 3 boot on
sudo parted /dev/sda -- set 3 bios_grub on

# --Formatting
# root
sudo mkfs.ext4 -L nixos /dev/sda1
# swap
sudo mkswap -L swap /dev/sda2
# boot
sudo mkfs.ext4 -L boot /dev/sda3


# --Mount
# root
sudo mount /dev/disk/by-label/nixos /mnt
# boot
sudo mkdir -p /mnt/boot
sudo mount /dev/disk/by-label/boot /mnt/boot
# swap
sudo swapon /dev/sda2

# --Configuration
sudo nixos-generate-config --root /mnt
sudo perl -pi -e "s/# (?=boot\.loader\.grub\.device)//g" /mnt/etc/nixos/configuration.nix
sudo perl -pi -e 's#(?<=boot\.loader\.grub\.device = )".*"#"/dev/disk/by-id/ata-QEMU_HARDDISK_QM00001"#g' /mnt/etc/nixos/configuration.nix
sudo perl -pi -e "s/# (?=services\.openssh\.enable)//g" /mnt/etc/nixos/configuration.nix


# --Install
sudo nixos-install --no-root-passwd

# --Reboot
sudo reboot
