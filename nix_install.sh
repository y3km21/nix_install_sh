#!/run/current-system/sw/bin/bash

#Parted
# make gpt partition table
sudo parted /dev/sda -- mklabel gpt
# add root partition
sudo parted /dev/sda -- mkpart primary 512MiB -4GiB
# add swap partition
sudo parted /dev/sda -- mkpart primary linux-swap -4GiB 100%
# add boot partition
sudo parted /dev/sda -- mkpart ESP fat32 1MiB 512MiB
sudo parted /dev/sda -- set 3 esp on

#Formatting
# root
sudo mkfs.ext4 -L nixos /dev/sda1
# swap
sudo mkswap -L swap /dev/sda2
# boot
sudo mkfs.fat -F 32 -n boot /dev/sda3


#Mount
# root
sudo mount /dev/disk/by-label/nixos /mnt
# boot
sudo mkdir -p /mnt/boot
sudo mount /dev/disk/by-label/boot /mnt/boot
# swap
sudo swapon /dev/sda2


