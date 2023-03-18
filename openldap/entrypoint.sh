#!/bin/bash

# Start the OpenLDAP server in the background
slapd -d 0 &

# Wait for the server to start up
sleep 2

# Import the bootstrap LDIF file
ldapadd -x -D "cn=admin,dc=my-domain,dc=com" -w password -f /etc/ldap/bootstrap.ldif

# Put the server in the foreground
tail -f /var/log/syslog
