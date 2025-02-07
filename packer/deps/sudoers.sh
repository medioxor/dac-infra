#!/bin/sh -eux

sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=sudo' /etc/sudoers

# Set up password-less sudo for the deploy user
echo 'deploy ALL=(ALL) NOPASSWD:ALL' >/etc/sudoers.d/99_deploy
chmod 440 /etc/sudoers.d/99_deploy
