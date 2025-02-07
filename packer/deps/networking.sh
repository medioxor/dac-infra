#!/bin/sh -eux

ubuntu_version="$(lsb_release -r | awk '{print $2}')";
major_version="$(echo "$ubuntu_version" | awk -F. '{print $1}')";

if [ "$major_version" -ge "18" ]; then
echo "Create netplan config for eth0"
cat <<EOF >/etc/netplan/01-netcfg.yaml;
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: true
EOF
fi

if [ "$major_version" -ge "16" ]; then
  sed -i 's/GRUB_CMDLINE_LINUX="\(.*\)"/GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0 \1"/g' /etc/default/grub;
  update-grub;
fi
