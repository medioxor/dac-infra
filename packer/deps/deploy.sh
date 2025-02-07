#!/bin/sh -eux

# set a default HOME_DIR environment variable if not set
HOME_DIR="${HOME_DIR:-/home/deploy}";

chown -R deploy "$HOME_DIR"/.ssh
chmod -R go-rwsx "$HOME_DIR"/.ssh
