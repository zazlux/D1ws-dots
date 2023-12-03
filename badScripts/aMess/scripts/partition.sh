#!/bin/bash


# exit if any command fails
set -e
set -x

# We use the gitlab username to grab ssh keys later

source /etc/os-release
# username defaults to 'anon'
# ask for a password

if [ "$ID" = "void" ]; then
	xbps-install -Syu xbps
	xbps-install -yu xbps
	xbps-install -Sy parted git
elif [ "$ID" = "arch" ]; then
	pacman -Syy
	pacman -S --noconfirm archlinux-keyring parted git
fi

# Configure Disk

if [ "$(lsblk | grep '^nvme0n1' )" ]; then
	disk=nvme0n1
	swap=/dev/nvme0n1p1
	partition=/dev/nvme0n1p2
elif [ "$(lsblk | grep '^sda' )" ]; then
	disk=sda
	swap=/dev/sda1
	partition=/dev/sda2
else
	echo "no disk found"
	exit 1
fi

# Check the disk exists.

## see how much ram there is

ram=$(free -h | sed -n '2p' | grep -Pom1 '\d(.\d)?' | head -c1)

ram=$(( ram + 1 ))

disksize=$(lsblk | grep $disk | head -n1 | awk '{print $4}' | grep -Po '\d\d?')

## assign swap size, depending on the RAM.

if [ "$disksize" -lt 12 ]; then
	swapsize=1
elif [ "$disksize" -lt 20 ]; then
	swapsize=$ram
elif [ "$ram" -gt 7 ];then
	swapsize=7
elif [ "$ram" -lt 5 ];then
	swapsize=$(( ram * 2 ))
else
	swapsize=$ram
fi

disk=/dev/$disk

echo -e '\n\n\n\n\n'
echo Disk is $disk, with $disksize GB
echo swap size is $swapsize GB

# user checks results
sleep 5

# check disks exists

[ -e $disk ]

parted -s $disk mklabel msdos

parted -s $disk mkpart primary linux-swap 512 "$swapsize"GB
parted -s $disk mkpart primary ext4 "$swapsize"GB 100%

parted -s $disk set 2 boot on

mkfs.ext4 $partition

mount $partition /mnt
swapid="$(mkswap $swap | tail -n1 | awk '{print $3}')"


if [ "$ID" = "void" ]; then
	echo | xbps-install -Sy -R https://alpha.de.repo.voidlinux.org/current -r /mnt base-system grub git make curl
	mount --rbind /sys /mnt/sys && mount --make-rslave /mnt/sys
	mount --rbind /dev /mnt/dev && mount --make-rslave /mnt/dev
	mount --rbind /proc /mnt/proc && mount --make-rslave /mnt/proc
	disk_uuid="$(blkid $partition | grep -Po 'UUID=".*[^ ]'  | awk '{print $1}')"
	echo "$disk_uuid    /    ext4    rw,relatime    0 1" > /mnt/etc/fstab
	echo "$swapid none swap sw 0 0" >> /mnt/etc/fstab
	echo 'repository=https://repo-de.voidlinux.org/current' > /etc/xbps.d/00-repository-main.conf
	cp /etc/resolv.conf /mnt/etc/
elif [ "$ID" = "arch" ]; then
	pacstrap /mnt base base-devel linux linux-firmware vim grub git
fi

[ -d .git ] && git clone . /mnt/etc/skel/.dots || git clone https://gitlab.com/andonome/dots /mnt/etc/skel/.dots

date +%B | tr '[:upper:]' '[:lower:]' > /mnt/etc/hostname

echo "#!/bin/bash
cd /etc/skel/.dots/setup
grub-install DISK
grub-mkconfig -o /boot/grub/grub.cfg
make ${1:-install}
" > /mnt/setup.sh

sed -i "s#DISK#$disk#g" /mnt/setup.sh

chmod +x /mnt/setup.sh

if [ "$ID" = "void" ]; then
	chroot /mnt/ /setup.sh
elif [ "$ID" = "arch" ]; then
	arch-chroot /mnt/ /setup.sh
fi

rm /mnt/setup.sh
reboot
