#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# mkdir -p /tmp/uploads/{corx,corr,log}
mkdir -p /tmp/uploads/
if [ -f /tmp/uploads/stop ]; then
    rm /tmp/uploads/stop
fi
# TODO: create tmpfs if necessary
chmod 0600 ssh_host_rsa_key
chmod 0600 ssh_host_dsa_key
/usr/sbin/sshd -D -f sshd_config -h "$DIR/ssh_host_dsa_key" -h "$DIR/ssh_host_rsa_key" -o "AuthorizedKeysFile $DIR/authorized_keys"