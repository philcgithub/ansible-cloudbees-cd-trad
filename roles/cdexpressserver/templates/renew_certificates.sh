#!/bin/sh

set -e

# make sure copied files will inherit owner+group from parent
chmod g+s {{ install_dir }}/apache/conf

# Make sure the certificate and private key files are
# never world readable, even just for an instant
umask 077

# copy letsencrypt files
cp "/etc/letsencrypt/live/{{ domain }}/fullchain.pem" "{{ install_dir }}/apache/conf/server.crt"
cp "/etc/letsencrypt/live/{{ domain }}/privkey.pem" "{{ install_dir }}/apache/conf/server.key"

chmod 400 "{{ install_dir }}/apache/conf/server.crt" "{{ install_dir }}/apache/conf/server.key"